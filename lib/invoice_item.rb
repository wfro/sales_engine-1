require_relative './parser'

class InvoiceItem
  include Parser

  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at,
              :invoice_item_repository

  def initialize(data, repo)
    @id                      = data[:id]
    @item_id                 = data[:item_id]
    @invoice_id              = data[:invoice_id]
    @quantity                = decimal(data[:quantity])
    @unit_price              = decimal(data[:unit_price])
    @created_at              = date(data[:created_at])
    @updated_at              = date(data[:updated_at])
    @invoice_item_repository = repo
    @invoice_item_repository.objects << self
  end

  def items
    invoice_item_repository.find_items(item_id)
  end

  def invoices
    invoice_item_repository.find_invoices(invoice_id)
  end
end
