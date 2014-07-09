# require_relative './lib_helper'
require_relative './transaction_repository'
require_relative './customer_repository'
require_relative './invoice_item_repository'
require_relative './invoice_repository'
require_relative './item_repository'
require_relative './merchant_repository'

require 'csv'
require 'bigdecimal'


class SalesEngine
  attr_reader :merchant_repository,
              :customer_repository,
              :invoice_item_repository,
              :invoice_repository,
              :item_repository,
              :transaction_repository
  def initialize(path)
  end

  def startup(path='data')
    @transaction_repository  = TransactionRepository.new("#{path}/transactions.csv", self)
    @merchant_repository     = MerchantRepository.new("#{path}/merchants.csv", self)
    @customer_repository     = CustomerRepository.new("#{path}/customers.csv",self)
    @invoice_item_repository = InvoiceItemRepository.new("#{path}/invoice_items.csv", self)
    @invoice_repository      = InvoiceRepository.new("#{path}/invoices.csv", self)
    @item_repository         = ItemRepository.new("#{path}/items.csv", self)
  end

  def find_items_by(id, attribute)
    item_repository.objects.find_all{|item| item.send(attribute) == id}
  end

  def find_invoices_by(id, attribute)
    invoice_repository.objects.find_all {|invoice| invoice.send(attribute) == id}
  end

  def find_merchant_by(id, attribute)
    merchant_repository.objects.find {|merchant| merchant.send(attribute) == id}
  end

  def find_transactions_by(id, attribute)
    transaction_repository.objects.find_all{|transaction| transaction.send(attribute) == id}
  end

  def find_invoice_items_by(id, attribute)
    invoice_item_repository.objects.find_all{|invoice_item| invoice_item.send(attribute) == id}
  end

  def find_customer_by(id, attribute)
    customer_repository.objects.find{|customer| customer.send(attribute) == id}
  end

  def successful_transaction?(id, attribute)
    find_transactions_by(id, attribute).any?{|transaction| transaction.result == "success"}
  end

  def create_invoice(data)
    invoice = Invoice.new({id: (invoice_repository.objects.count + 1), customer_id: data[:customer].id, merchant_id: data[:merchant].id, status: data[:status], created_at: Time.new.to_s, updated_at: Time.new.to_s}, invoice_repository)
    invoice_repository.objects << invoice
    invoice
  end

  def create_invoice_item(data)
    item_hash = data[:items].group_by{|item| item.id}
    item_hash.each do |key, value|
      invoice_item = InvoiceItem.new({id: (invoice_item_repository.objects.count + 1), item_id: key, invoice_id: invoice_repository.objects.count, quantity: value.count, unit_price: value.find {|value| value}.unit_price, created_at: Time.new.to_s, updated_at: Time.new.to_s}, invoice_item_repository)
      invoice_item_repository.objects << invoice_item
    end
  end

  def create_transaction(data, id)
    transaction = Transaction.new({id: (transaction_repository.objects.count +1), invoice_id: id, credit_card_number: data[:credit_card_number], result: data[:result], created_at: Time.new.to_s, updated_at: Time.new.to_s}, transaction_repository)
    transaction_repository.objects << transaction
  end
end
