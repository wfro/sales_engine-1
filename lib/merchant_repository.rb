require './lib/finder'
require 'pry'

class MerchantRepository
  include Finder
  def self.from_file(file_name= './data/merchants.csv', engine)
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

  def find_invoice_items_by_invoices(invoices)
    invoices.map{|invoice| sales_engine.find_invoice_items_by(invoice.id, "invoice_id").first}
  end

  def find_invoice_items(date)
    sales_engine.find_invoice_items_by(date, "created_at")
  end

  def most_revenue(number_of_merchants)
    objects.each do |object|
      invoices = find_invoices(object.id)
      invoice_items = find_invoice_items_by_invoices(invoices)
      revenue = 0
      invoice_items.each {|invoice_item| revenue += (invoice_item.quantity * invoice_item.unit_price)}
      object.revenue = revenue
    end
      sorted = objects.sort_by{|object| object.revenue}.reverse
      sorted[0...number_of_merchants]
  end

  def most_items(number_of_merchants)
    objects.each do |object|
      invoices = find_invoices(object.id)
      invoice_items = find_invoice_items_by_invoices(invoices)
      items_sold = 0
      invoice_items.each {|invoice_item| items_sold += invoice_item.quantity}
      object.items_sold = items_sold
    end
      sorted = objects.sort_by{|object| object.items_sold}.reverse
      sorted[0...number_of_merchants]
  end

  def revenue(date)
    invoice_items = find_invoice_items(date)
    invoice_items.reduce(0){|sum, invoice_item| sum + (invoice_item.quantity * invoice_item.unit_price)}
  end
end
