require 'pry'
class Merchant
  include Parser

  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :merchant_repository
  attr_accessor :stored_revenue, :items_sold

  def initialize(data, path='data', repo)
    @id                  = data[:id]
    @name                = data[:name]
    @created_at          = date(data[:created_at])
    @updated_at          = date(data[:updated_at])
    @merchant_repository = repo

  end

  def items
    merchant_repository.find_items(id)
  end

  def invoices
    merchant_repository.find_invoices(id)
  end

  def revenue(date=nil)
    if date
      found_revenue = merchant_repository.find_revenue(self, date, 'created_at')
    else
      found_revenue = merchant_repository.find_revenue(self)
    end
    dollars(found_revenue)
  end

  def favorite_customer
    merchant_repository.find_favorite_customer(self)
  end
end
