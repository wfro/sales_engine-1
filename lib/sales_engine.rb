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

  def startup(path='data')
    @invoice_repository      =
                    InvoiceRepository.new("#{path}/invoices.csv", self)
    @invoice_item_repository =
                    InvoiceItemRepository.new("#{path}/invoice_items.csv", self)
    @transaction_repository  =
                    TransactionRepository.new("#{path}/transactions.csv", self)
    @merchant_repository     =
                    MerchantRepository.new("#{path}/merchants.csv", self)
    @customer_repository     =
                    CustomerRepository.new("#{path}/customers.csv",self)
    @item_repository         =
                    ItemRepository.new("#{path}/items.csv", self)
  end

  def find_items_by(id, attribute)
    item_repository.objects.find_all{|item| item.send(attribute) == id}
  end

  def find_invoices_by(id, attribute)
    invoice_repository.objects.find_all do |invoice|
      invoice.send(attribute) == id
    end
  end

  def find_merchant_by(id, attribute)
    merchant_repository.objects
      .find {|merchant| merchant.send(attribute) == id}
  end

  def find_transactions_by(id, attribute)
    transaction_repository.objects.find_all do |transaction|
      transaction.send(attribute) == id
    end
  end

  def find_invoice_items_by(id, attribute)
    invoice_item_repository.objects.find_all do |invoice_item|
      invoice_item.send(attribute) == id
    end
  end

  def find_customer_by(id, attribute)
    customer_repository.objects.find{|customer| customer.send(attribute) == id}
  end

  def successful_transaction?(id, attribute)
    find_transactions_by(id, attribute).any? do |transaction|
      transaction.result == "success"
    end
  end

  def create_invoice(data)
    invoice = Invoice.new({id: (invoice_repository.objects.count + 1),
                           customer_id: data[:customer].id,
                           merchant_id: data[:merchant].id,
                           status: data[:status],
                           created_at: Time.new.to_s,
                           updated_at: Time.new.to_s},
                           invoice_repository)
    invoice_repository.objects << invoice
    invoice
  end

  def create_invoice_item(data)
    item_hash = data[:items].group_by{|item| item.id}
    item_hash.each do |key, value|
      id           = invoice_item_repository.objects.count + 1
      invoice_id   = invoice_repository.objects.count
      quantity     = value.count
      unit_price   = value[0].unit_price
      invoice_item = InvoiceItem.new({id: id,
                                      item_id: key,
                                      invoice_id: invoice_id,
                                      quantity: quantity,
                                      unit_price: unit_price,
                                      created_at: Time.new.to_s,
                                      updated_at: Time.new.to_s},
                                      invoice_item_repository)
      invoice_item_repository.objects << invoice_item
    end
  end

  def create_transaction(data, id)
    transaction_id = (transaction_repository.objects.count +1)
    credit_card    =  data[:credit_card_number]
    transaction    = Transaction.new({id: transaction_id,
                                   invoice_id: id,
                                   credit_card_number: credit_card,
                                   result: data[:result],
                                   created_at: Time.new.to_s,
                                   updated_at: Time.new.to_s},
                                   transaction_repository)
    transaction_repository.objects << transaction
  end
end
