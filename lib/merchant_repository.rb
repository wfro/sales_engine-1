require './lib/finder'
require 'pry'

class MerchantRepository
  include Finder
  def self.from_file(file_name='./data/merchants.csv', klass, engine)
    merchants = Loader.read(file_name, Merchant, self)
    new(merchants, engine)
  end

  attr_reader :objects, :sales_engine
  def initialize(merchants, engine)
    @objects = merchants
    @sales_engine = engine
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

  def find_invoices(id)
    sales_engine.find_invoices_by(id, "merchant_id")
  end

  def find_invoice_items(invoices)
    invoices.map{|invoice| sales_engine.find_invoice_items_by(invoice.id, "invoice_id").first}
  end

  def most_revenue(number_of_merchants)
    objects.each do |object|
      invoices = find_invoices(object.id)
      invoice_items = find_invoice_items(invoices)
      revenue = 0
      invoice_items.each {|invoice_item| revenue += (invoice_item.quantity * invoice_item.unit_price)}
      object.revenue = revenue
    end
      sorted = objects.sort_by{|object| object.revenue}.reverse
      sorted[0...number_of_merchants]
  end

end
