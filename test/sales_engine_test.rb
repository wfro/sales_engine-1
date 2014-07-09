require_relative 'test_helper'
require 'bigdecimal'

class SalesEngineTest < Minitest::Test
  attr_reader :sales_engine

  def setup
    @sales_engine = SalesEngine.new('./test/fixtures')
    sales_engine.startup("test/fixtures")
  end

  def test_it_exists
    assert sales_engine
  end

  def test_it_loads_repositories
    sales_engine.merchant_repository.objects
    sales_engine.customer_repository.objects
    sales_engine.invoice_item_repository.objects
    sales_engine.invoice_repository.objects
    sales_engine.item_repository.objects
    sales_engine.transaction_repository.objects
  end

  def test_it_finds_items_by
    items = sales_engine.find_items_by(1, "merchant_id")
    assert_equal 12, items.count
    assert_kind_of Item, items[1]
  end

  def test_it_finds_invoices_by
    invoices = sales_engine.find_invoices_by(1, "merchant_id")
    assert_equal 1, invoices.count
    assert_kind_of Invoice, invoices[0]
  end

  def test_it_finds_transactions_by
    transactions = sales_engine.find_transactions_by(1, "invoice_id")
    assert_equal 1, transactions.count
    assert_kind_of Transaction, transactions[0]
  end

  def test_it_finds_invoice_items_by
    invoice_items = sales_engine.find_invoice_items_by(1, 'invoice_id')
    assert_equal 8, invoice_items.count
    assert_kind_of InvoiceItem, invoice_items[0]
  end

  def test_it_finds_a_customer_by
    customer = sales_engine.find_customer_by(1, 'id')
    assert_kind_of Customer, customer
  end

  def test_it_finds_a_merchant_by
    merchant = sales_engine.find_merchant_by(26, 'id')
    assert_kind_of Merchant, merchant
  end

  def business_intelligence
    engine = SalesEngine.new("./test/fixtures/business_intelligence")
    engine.startup('test/fixtures/business_intelligence')
    @business_intelligence_engine = engine
    @customer = engine.customer_repository.random
    @merchant = engine.merchant_repository.random
    @item1    = engine.item_repository.objects[0]
    @item2    = engine.item_repository.objects[1]
    @items    = [@item1, @item2]
  end

  def test_it_doesnt_count_failed_transactions
    business_intelligence
    successful_transaction = @business_intelligence_engine.successful_transaction?(1, 'invoice_id')
    unsuccessful_transaction = @business_intelligence_engine.successful_transaction?(2, 'invoice_id')

    assert successful_transaction
    refute unsuccessful_transaction
  end

  def test_it_creates_an_invoice
    business_intelligence
    result = @business_intelligence_engine.create_invoice({customer: @customer, merchant: @merchant, status: "shipped", items: @items})
    assert_kind_of Invoice, result
  end

  def test_it_creates_invoice_items
    business_intelligence
    assert_equal 4, @business_intelligence_engine.invoice_item_repository.objects.count
    result = @business_intelligence_engine.create_invoice_item({items: @items})
    assert_equal 6, @business_intelligence_engine.invoice_item_repository.objects.count
  end

  def test_it_creates_a_transaction
    business_intelligence
    assert_equal 2, @business_intelligence_engine.transaction_repository.objects.count
    result = @business_intelligence_engine.create_transaction({credit_card_number: "4444333322221111", expiration_date: "10-13", result: "success"}, "5")
    assert_equal 3, @business_intelligence_engine.transaction_repository.objects.count
  end
end
