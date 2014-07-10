require_relative './finder'
require_relative './loader'
require_relative './invoice'

class InvoiceRepository
  include Finder

  attr_reader   :sales_engine
  attr_accessor :objects

  def initialize(filename, engine)
    @sales_engine = engine
    @objects      = Loader.read(filename, Invoice, self).to_a
  end

  def find_transactions(id)
    sales_engine.find_transactions_by(id, 'invoice_id')
  end

  def find_invoice_items(id)
    sales_engine.find_invoice_items_by(id, 'invoice_id')
  end

  def find_items(id)
    invoice_items = find_invoice_items(id)
    item_ids      = invoice_items.collect {|inv_item| inv_item.item_id}

    items = item_ids.map do |item_id|
      item = sales_engine.find_items_by(item_id, 'id').first
    end
    items.reject{|item| item.nil?}
  end

  def find_customer(customer_id)
    sales_engine.find_customer_by(customer_id, 'id')
  end

  def find_merchant(merchant_id)
    sales_engine.find_merchant_by(merchant_id, 'id')
  end

  def find_by_customer_id(customer_id)
    objects.find {|object| object.customer_id == customer_id}
  end

  def find_all_by_customer_id(customer_id)
    objects.find_all {|object| object.customer_id == customer_id}
  end

  def find_by_merchant_id(merchant_id)
    objects.find {|object| object.merchant_id == merchant_id}
  end

  def find_all_by_merchant_id(merchant_id)
    objects.find_all {|object| object.merchant_id == merchant_id}
  end

  def find_by_status(status)
    objects.find {|object| object.status == status}
  end

  def find_all_by_status(status)
    objects.find_all {|object| object.status == status}
  end

  def create(data)
    invoice = sales_engine.create_invoice(data)
    sales_engine.create_invoice_item(data)
    invoice
  end

  def charge(data, id)
    sales_engine.create_transaction(data, id)
  end
end
