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
    @id                      = data[:id].to_i
    @item_id                 = data[:item_id].to_i
    @invoice_id              = data[:invoice_id].to_i
    @quantity                = decimal(data[:quantity])
    @unit_price              = decimal(data[:unit_price])
    @created_at              = date(data[:created_at])
    @updated_at              = date(data[:updated_at])
    @invoice_item_repository = repo
  end

  def item
    invoice_item_repository.find_items(item_id).first
  end

  def invoice
    invoice_item_repository.find_invoices(invoice_id).first
  end
end
