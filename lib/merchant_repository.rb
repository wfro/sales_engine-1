require_relative './finder'
require_relative './loader'
require_relative './merchant'

class MerchantRepository
  include Finder
  include Parser

  attr_reader   :sales_engine
  attr_accessor :objects

  def initialize(filename, engine)
    @sales_engine = engine
    @objects      = Loader.read(filename, Merchant, self).to_a
  end

  def find_by_name(name)
    objects.find {|object| object.name == name}
  end

  def find_all_by_name(name)
    objects.find_all {|object| object.name == name}
  end

  def find_items(id)
    sales_engine.find_items_by(id, "merchant_id")
  end

  def find_invoices(id, attribute='merchant_id')
    sales_engine.find_invoices_by(id, attribute)
  end

  def find_invoice_items_by_invoices(invoices)
    invoices.map do |invoice|
      sales_engine.find_invoice_items_by(invoice.id, "invoice_id").first
    end
  end

  def find_invoice_items(date)
    sales_engine.find_invoice_items_by(date, "created_at")
  end

  def find_successful_invoices(id, attribute)
    find_invoices(id).find_all do |invoice|
      sales_engine.successful_transaction?(invoice.id, 'invoice_id')
    end
  end

  def calculated_items_by_invoices(invoices)
    invoices.reduce(0) do |sum, invoice|
      sum + invoice.invoice_items.reduce(0) do |sum, invoice_item|
        sum + invoice_item.quantity
      end
    end
  end

  def calculated_revenue_by_invoices(invoices)
    invoices.reduce(0) do |sum, invoice|
      sum + invoice.invoice_items.reduce(0) do |sum, invoice_item|
        sum + (invoice_item.quantity * invoice_item.unit_price)
      end
    end
  end

  def find_items_sold(merchant)
    invoices = find_successful_invoices(merchant.id, 'id')
    merchant.items_sold = calculated_items_by_invoices(invoices)
  end

  def find_revenue(merchant, search_by=merchant.id, attribute='merchant_id')
    invoices = find_successful_invoices(merchant.id, 'id')
    merchant.stored_revenue = calculated_revenue_by_invoices(invoices)
  end

  def find_revenue_by_date(date, merchant)
    invoices = find_invoices(date, 'created_at').find_all do |invoice|
      sales_engine.successful_transaction?(invoice.id, 'invoice_id')
    end
    merchant_invoices = invoices.find_all do |invoice|
      invoice.merchant_id == merchant.id
    end
    found_revenue = calculated_revenue_by_invoices(merchant_invoices)
  end

  def sort_by(x, attribute)
    sorted = objects.sort_by{|object| object.send(attribute)}.reverse
    sorted[0...x]
  end

  def most_revenue(number_of_merchants)
    sort_by(number_of_merchants, "stored_revenue")
  end

  def most_items(number_of_merchants)
    sort_by(number_of_merchants, "items_sold")
  end

  def revenue(date)
    invoices = find_invoices(date, 'created_at').find_all do |invoice|
      sales_engine.successful_transaction?(invoice.id, 'invoice_id')
    end
    found_revenue = calculated_revenue_by_invoices(invoices)
    dollars(found_revenue)
  end

  def find_favorite_customer(merchant)
   invoices = find_successful_invoices(merchant.id, 'id')

   customers = invoices.map do |invoice|
     sales_engine.find_customer_by(invoice.customer_id, 'id')
   end.uniq

   favorite_customer = ['', 0]
   customers.each do |customer|
     customer_invoices = invoices.find_all do
        |invoice| invoice.customer_id == customer.id
      end
     successes = customer_invoices.count
       if successes > favorite_customer[1]
         favorite_customer = [customer, successes]
       end
     end

     favorite_customer[0]
   end

  def find_customers_with_pending_invoices(merchant)
    invoices = find_invoices(merchant.id)
    customers = invoices.map do |invoice|
      sales_engine.find_customer_by(invoice.customer_id, 'id')
      end
    pending_customers = []
    customers.each do |customer|
      customer_invoices = invoices.find_all do |invoice|
        invoice.customer_id == customer.id
      end
      customer_invoices.each do |invoice|
        transactions = sales_engine.
        find_transactions_by(invoice.id, 'invoice_id')
        if transactions.empty? || transactions.none? do |transaction|
          transaction.result == "success"
        end
           pending_customers << customer
        end
      end
    end
   pending_customers
  end
end
