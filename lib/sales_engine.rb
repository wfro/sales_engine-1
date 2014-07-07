require 'pry'

class SalesEngine
  attr_reader :merchant_repository,
              :customer_repository,
              :invoice_item_repository,
              :invoice_repository,
              :item_repository,
              :transaction_repository

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
end
