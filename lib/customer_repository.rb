require './lib/finder'

class CustomerRepository
  include Finder

  attr_reader   :sales_engine
  attr_accessor :objects
  def initialize(filename, engine)
    @objects = []
    @sales_engine = engine
    Loader.read(filename, Customer, self)
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

  def find_transactions(id)
   invoices = sales_engine.find_invoices_by(id, "customer_id")
   transactions = []
   invoices.each do |invoice|
     transactions << sales_engine.find_transactions_by(invoice.id, "invoice_id")
    end
   transactions.flatten
  end

  def find_favorite_merchant(id)

  end
end
