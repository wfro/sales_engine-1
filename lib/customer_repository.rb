require './lib/finder'

class CustomerRepository
  include Finder
  def self.from_file(file_name='./data/customers.csv', engine)
    customers = Loader.read(file_name, Customer, self)
    new(customers, engine)
  end

  attr_reader :objects, :sales_engine
  def initialize(customers, engine)
    @objects = customers
    @sales_engine = engine
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
end
