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
    @objects = Loader.read(filename, Merchant, self).to_a
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
    invoices.map{|invoice| sales_engine.find_invoice_items_by(invoice.id, "invoice_id").first}
  end

  def find_invoice_items(date)
    sales_engine.find_invoice_items_by(date, "created_at")
  end

  def find_successful_invoices(id, attribute)
    find_invoices(id).find_all do |invoice|
      sales_engine.successful_transaction?(invoice.id, 'invoice_id')
    end
  end

  def find_revenue(merchant, search_by=merchant.id, attribute='merchant_id')
    invoices = find_invoices(search_by, attribute).find_all{|invoice| sales_engine.successful_transaction?(invoice.id, 'invoice_id')}
    invoice_items = find_invoice_items_by_invoices(invoices)
    invoice_items.each {|invoice_item| merchant.stored_revenue += (invoice_item.quantity * invoice_item.unit_price)}
    merchant.stored_revenue
  end

  def most_revenue(number_of_merchants)
    objects.each do |object|
      find_revenue(object)
    end
      sorted = objects.sort_by{|object| object.stored_revenue}.reverse
      sorted[0...number_of_merchants]
  end

  def most_items(number_of_merchants)
    objects.each do |object|
      invoices = find_successful_invoices(object.id, 'id')
      invoice_items = find_invoice_items_by_invoices(invoices)
      invoice_items.each {|invoice_item| object.items_sold += invoice_item.quantity}
    end
      sorted = objects.sort_by{|object| object.items_sold}.reverse
      sorted[0...number_of_merchants]
  end

  def revenue(date)
    invoice_items = find_invoice_items(date).find_all{|invoice_item| sales_engine.successful_transaction?(invoice_item.invoice_id, 'invoice_id')}
    found_revenue = invoice_items.reduce(0){|sum, invoice_item| sum + (invoice_item.quantity * invoice_item.unit_price)}
    dollars(found_revenue)
  end

  def find_favorite_customer(merchant)
   favorite_customer = ['', 0]
   invoices = find_invoices(merchant.id).find_all{|invoice| sales_engine.successful_transaction?(invoice.id, 'invoice_id')}
   customers = invoices.map {|invoice| sales_engine.find_customer_by(invoice.customer_id, 'id')}.uniq
   customers.each do |customer|
     invoices = find_invoices(customer.id, 'customer_id')
     successes = invoices.count
       if successes > favorite_customer[1]
         favorite_customer = [customer, successes]
       end
     end
     favorite_customer[0]
   end

  def find_customers_with_pending_invoices(merchant)
    invoices = find_invoices(merchant.id)
    customers = invoices.map { |invoice| sales_engine.find_customer_by(invoice.customer_id, 'id')}
    pending_customers = []
    customers.each do |customer|
      customer_invoices = invoices.find_all { |invoice| invoice.customer_id == customer.id }
      customer_invoices.each do |invoice|
        transactions = sales_engine.find_transactions_by(invoice.id, 'invoice_id')
        if transactions.empty? || transactions.none? {|transaction| transaction.result == "success"}
           pending_customers << customer
        end
      end
    end
   pending_customers
  end
end
