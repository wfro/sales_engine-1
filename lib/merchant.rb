require_relative './parser'

class Merchant
  include Parser

  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :merchant_repository

  attr_accessor :stored_revenue, :items_sold

  def initialize(data, repo)
    @id                  = data[:id].to_i
    @name                = data[:name]
    @created_at          = date(data[:created_at])
    @updated_at          = date(data[:updated_at])
    @merchant_repository = repo
    @stored_revenue      = merchant_repository.find_revenue(self)
    @items_sold          = merchant_repository.find_items_sold(self)
  end

  def items
    merchant_repository.find_items(id)
  end

  def invoices
    merchant_repository.find_invoices(id)
  end

  def revenue(date=nil)
    return dollars(stored_revenue) if date.nil?
    found_revenue = merchant_repository.find_revenue_by_date(date, self)
    dollars(found_revenue)
  end

  def favorite_customer
    merchant_repository.find_favorite_customer(self)
  end

  def customers_with_pending_invoices
    merchant_repository.find_customers_with_pending_invoices(self)
  end
end
