require './test/test_helper'

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :invoice_repo
  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    @invoice_repo = InvoiceRepository.from_file('./test/fixtures/invoices.csv', engine)
  end

  def test_it_has_invoices
    assert invoice_repo.objects
  end

  def test_it_finds_transactions
    transactions = invoice_repo.find_transactions('1')
    assert_equal 1, transactions.count
    assert_kind_of Transaction, transactions[0]
  end

  def test_it_finds_invoice_items
    invoice_items = invoice_repo.find_invoice_items('1')
    assert_equal 8, invoice_items.count
    assert_kind_of InvoiceItem, invoice_items[0]
  end

  def test_it_finds_items
    items = invoice_repo.find_items('1')
    assert_equal 1, items.count
    assert_kind_of Item, items[0]
  end

  def test_it_finds_a_customer
    customer = invoice_repo.find_customer('1')
    assert_kind_of Customer, customer
  end

  def test_it_finds_a_merchant
    merchant = invoice_repo.find_merchant('26')
    assert_kind_of Merchant, merchant
  end
end
