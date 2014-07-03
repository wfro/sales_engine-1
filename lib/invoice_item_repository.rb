class InvoiceItemRepository
  include Finder

  def self.from_file(filename='./data/invoice_items.csv', engine)
    invoice_items = Loader.read(filename, InvoiceItem, self)
    new(invoice_items, engine)
  end

  attr_reader :objects, :sales_engine
  def initialize(invoice_items, engine)
    @objects = invoice_items
    @sales_engine = engine
  end

  def find_items(item_id)
    sales_engine.find_items_by(item_id, "id")
  end

  def find_invoices(invoice_id)
    sales_engine.find_invoices_by(invoice_id, "id")
  end

  def find_by_item_id(item_id)
    objects.find {|object| object.item_id == item_id}
  end

  def find_all_by_item_id(item_id)
    objects.find_all {|object| object.item_id == item_id}
  end

  def find_by_quantity(quantity)
    objects.find {|object| object.quantity == quantity}
  end

  def find_all_by_quantity(quantity)
    objects.find_all {|object| object.quantity == quantity}
  end

  def find_by_unit_price(unit_price)
    objects.find {|object| object.unit_price == unit_price}
  end

  def find_all_by_unit_price(unit_price)
    objects.find_all {|object| object.unit_price == unit_price}
  end

  def find_by_invoice_id(invoice_id)
    objects.find {|object| object.invoice_id == invoice_id}
  end

  def find_all_by_invoice_id(invoice_id)
    objects.find_all {|object| object.invoice_id == invoice_id}
  end
end
