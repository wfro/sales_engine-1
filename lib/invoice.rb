require_relative './parser'

class Invoice
  include Parser

  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :invoice_repository

  def initialize(data, repo)
    @id                 = data[:id].to_i
    @customer_id        = data[:customer_id].to_i
    @merchant_id        = data[:merchant_id].to_i
    @status             = data[:status]
    @created_at         = date(data[:created_at])
    @updated_at         = date(data[:updated_at])
    @invoice_repository = repo
  end

  def transactions
    invoice_repository.find_transactions(id)
  end

  def invoice_items
    invoice_repository.find_invoice_items(id)
  end

  def items
    invoice_repository.find_items(id)
  end

  def customer
    invoice_repository.find_customer(customer_id)
  end

  def merchant
    invoice_repository.find_merchant(merchant_id)
  end

  def charge(data)
    invoice_repository.charge(data, id)
  end
end
