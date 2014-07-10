require_relative './parser'

class Item
  include Parser

  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :merchant_id,
              :created_at,
              :updated_at,
              :item_repository

  attr_accessor :revenue_generated, :number_sold

  def initialize(data, repo)
    @id                 = data[:id].to_i
    @name               = data[:name]
    @description        = data[:description]
    @unit_price         = decimal(data[:unit_price])
    @merchant_id        = data[:merchant_id].to_i
    @created_at         = date(data[:created_at])
    @updated_at         = date(data[:updated_at])
    @item_repository    = repo
    @revenue_generated  = item_repository.find_revenue_generated(self)
    @number_sold        = item_repository.find_number_sold(self)
  end

  def invoice_items
    item_repository.find_invoice_items(id)
  end

  def merchant
    item_repository.find_merchant(merchant_id)
  end

  def best_day
    item_repository.find_best_day(self)
  end
end
