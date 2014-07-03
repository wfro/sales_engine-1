require './lib/finder'

class InvoiceRepository
  include Finder
  def self.from_file(file_name='./data/invoices.csv', engine)
    invoices = Loader.read(file_name, Invoice, self)
    new(invoices, engine)
  end

  attr_reader :objects, :sales_engine
  def initialize(invoices, engine)
    @objects = invoices
    @sales_engine = engine
  end

  def find_transactions(id)
    sales_engine.find_transactions_by(id, 'invoice_id')
  end

  def find_invoice_items(id)
    sales_engine.find_invoice_items_by(id, 'invoice_id')
  end

  def find_items(id)
    invoice_items = find_invoice_items(id)
    item_ids = invoice_items.collect {|inv_item| inv_item.item_id}
    items = []
    item_ids.each do |item_id|
      item = sales_engine.find_items_by(item_id, 'id').first
      items << item unless item == nil
    end
    items
  end

  def find_customer(customer_id)
    sales_engine.find_customer_by(customer_id, 'id')
  end

  def find_merchant(merchant_id)
    sales_engine.find_merchant_by(merchant_id, 'id')
  end
end
