require_relative './parser'

class Customer
  include Parser

  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at,
              :customer_repository
              
  def initialize(data, repo)
    @id                  = data[:id].to_i
    @first_name          = data[:first_name]
    @last_name           = data[:last_name]
    @created_at          = date(data[:created_at])
    @updated_at          = date(data[:updated_at])
    @customer_repository = repo
  end

  def invoices
    customer_repository.find_invoices(id)
  end

  def transactions
   customer_repository.find_transactions(id)
  end

  def favorite_merchant
   customer_repository.find_favorite_merchant(id)
  end
end
