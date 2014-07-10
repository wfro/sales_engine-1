require_relative './finder'
require_relative './loader'
require_relative './customer'

class CustomerRepository
  include Finder

  attr_reader   :sales_engine
  attr_accessor :objects
  
  def initialize(filename, engine)
    @sales_engine = engine
    @objects      = Loader.read(filename, Customer, self)
  end

  def find_invoices(id)
    sales_engine.find_invoices_by(id, "customer_id")
  end

  def find_by_first_name(first_name)
    objects.find {|object| object.first_name == first_name}
  end

  def find_all_by_first_name(first_name)
    objects.find_all {|object| object.first_name == first_name}
  end

  def find_by_last_name(last_name)
    objects.find {|object| object.last_name == last_name}
  end

  def find_all_by_last_name(last_name)
    objects.find_all {|object| object.last_name == last_name}
  end

  def find_successful_invoices(id)
    find_invoices(id).find_all do
      |invoice| sales_engine.successful_transaction?(invoice.id, 'invoice_id')
    end
  end

  def find_transactions(id)
    invoices = sales_engine.find_invoices_by(id, "customer_id")
    transactions = invoices.map do
       |invoice| sales_engine.find_transactions_by(invoice.id, "invoice_id")
     end.flatten
  end

  def find_favorite_merchant(id)
    invoices = find_successful_invoices(id)
    hash = invoices.group_by {|invoice| invoice.merchant_id}
    best_merchant = ['id', 0]
    hash.each do |key, value|
      if value.count > best_merchant[1]
        best_merchant = [key, value]
      end
    end
    sales_engine.find_merchant_by(best_merchant[0], 'id')
  end
end
