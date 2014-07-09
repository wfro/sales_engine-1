require_relative './parser'

class Transaction
  include Parser

  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :result,
              :created_at,
              :updated_at,
              :transaction_repository

  def initialize(data,repo)
    @id                     = data[:id].to_i
    @invoice_id             = data[:invoice_id].to_i
    @credit_card_number     = data[:credit_card_number]
    @result                 = data[:result]
    @created_at             = date(data[:created_at])
    @updated_at             = date(data[:updated_at])
    @transaction_repository = repo
  end

  def invoice
    transaction_repository.find_invoices(id).last
  end
end
