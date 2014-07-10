require './test/test_helper'

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :invoice_repo
  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    @invoice_repo = engine.invoice_repository
  end

  def test_it_has_invoices
    assert invoice_repo.objects
  end

  def test_it_finds_transactions
    transactions = invoice_repo.find_transactions(1)
    assert_equal 1, transactions.count
    assert_kind_of Transaction, transactions[0]
  end

  def test_it_finds_invoice_items
    invoice_items = invoice_repo.find_invoice_items(1)
    assert_equal 8, invoice_items.count
    assert_kind_of InvoiceItem, invoice_items[0]
  end

  def test_it_finds_items
    items = invoice_repo.find_items(1)
    assert_equal 2, items.count
    assert_kind_of Item, items[0]
  end

  def test_it_finds_a_customer
    customer = invoice_repo.find_customer(1)
    assert_kind_of Customer, customer
  end

  def test_it_finds_a_merchant
    merchant = invoice_repo.find_merchant(26)
    assert_kind_of Merchant, merchant
  end

  def test_it_finds_by_customer_id
    result = invoice_repo.find_by_customer_id(1)
    assert_equal 1, result.id
  end

  def test_it_finds_all_by_customer_id
    result = invoice_repo.find_all_by_customer_id(1)
    assert_equal 16, result.count
  end

  def test_it_finds_by_merchant_id
    result = invoice_repo.find_by_merchant_id(27)
    assert_equal 9, result.id
  end

  def test_it_finds_all_by_merchant_id
    result = invoice_repo.find_all_by_merchant_id(27)
    assert_equal 1, result.count
  end

  def test_it_finds_by_status
    result = invoice_repo.find_by_status('shipped')
    assert_equal 1, result.id
  end

  def test_it_finds_all_by_status
    result = invoice_repo.find_all_by_status('shipped')
    assert_equal 19, result.count
  end

  def business_intelligence
    engine = SalesEngine.new
    engine.startup('test/fixtures/business_intelligence')
    @business_intelligence_repo = engine.invoice_repository
    @transaction_business_intelligence_repo = engine.transaction_repository
    @customer = engine.customer_repository.random
    @merchant = engine.merchant_repository.random
    @items    = (1..3).map {engine.item_repository.random}
  end

  def test_it_creates_an_invoice
    business_intelligence
    assert_equal 4, @business_intelligence_repo.objects.count
    result = @business_intelligence_repo.create({customer: @customer, merchant: @merchant, status: "shipped", items: @items})
    assert_equal 5, @business_intelligence_repo.objects.count
    assert_kind_of Invoice, result
  end

  def test_it_creates_a_transaction
    business_intelligence
    assert_equal 2, @transaction_business_intelligence_repo.objects.count
    result = @business_intelligence_repo.charge({credit_card_number: "4444333322221111", expiration_date: "10-13", result: "success"}, "5")
    assert_equal 3, @transaction_business_intelligence_repo.objects.count
  end
end
