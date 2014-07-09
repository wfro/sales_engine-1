require_relative './finder'
require_relative './loader'
require_relative './item'

class ItemRepository
  include Finder
  include Parser

  attr_reader   :sales_engine
  attr_accessor :objects
  def initialize(filename, engine)
    @sales_engine  = engine
    @objects = Loader.read(filename, Item, self).to_a
  end

  def find_invoice_items(id)
    sales_engine.find_invoice_items_by(id, "item_id")
  end

  def find_merchant(merchant_id)
    sales_engine.find_merchant_by(merchant_id, "id")
  end

  def find_by_name(name)
    objects.find {|object| object.name == name}
  end

  def find_all_by_name(name)
    objects.find_all {|object| object.name == name}
  end

  def find_by_unit_price(dollars)
    unit_price = cents(dollars)
    objects.find {|object| object.unit_price == unit_price}
  end

  def find_all_by_unit_price(dollars)
    unit_price = cents(dollars)
    objects.find_all {|object| object.unit_price == unit_price}
  end

  def find_by_merchant_id(merchant_id)
    objects.find {|object| object.merchant_id == merchant_id}
  end

  def find_all_by_merchant_id(merchant_id)
    objects.find_all {|object| object.merchant_id == merchant_id}
  end

  def find_revenue_generated(item)
    invoice_items = find_successful_invoice_items(item.id)
    item.revenue_generated = invoice_items.reduce(0) do |sum, invoice_item|
      sum += invoice_item.quantity * invoice_item.unit_price
    end
  end

  def most_revenue(x)
    sort_by(x, 'revenue_generated')
  end

  def find_number_sold(item)
    invoice_items = find_successful_invoice_items(item.id)
    item.number_sold = invoice_items.reduce(0) do |sum, invoice_item|
      sum += invoice_item.quantity
    end
  end

  def most_items(x)
    sort_by(x, 'number_sold')
  end

  def find_successful_invoice_items(id)
    find_invoice_items(id).find_all do |invoice_item|
      sales_engine.successful_transaction?(invoice_item.invoice_id, 'invoice_id')
    end
  end

  def sort_by(x, attribute)
    objects.sort_by {|object| object.send(attribute)}.reverse
    objects[0...x]
  end

  def find_best_day(item)
    invoice_items = find_invoice_items(item.id)
    invoice_items_with_revenue = invoice_items.each_with_index do |invoice_item|
      id = invoice_item.invoice_id
      id = (invoice_item.quantity * invoice_item.unit_price)
    end
    sorted_invoice_items_with_revenue = invoice_items_with_revenue.sort_by{|invoice_item| invoice_item.unit_price * invoice_item.quantity}.reverse
    highest_revenue = sorted_invoice_items_with_revenue.first
    invoice = sales_engine.find_invoices_by(highest_revenue.invoice_id, "id")
    invoice[0].created_at
  end
end
