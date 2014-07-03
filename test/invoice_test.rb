require './test/test_helper'

class InvoiceTest < Minitest::Test
  attr_reader :invoice
  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    data = {id: "1", customer_id: "1", merchant_id: "26", status: "shipped",
      created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC"}
    repo = InvoiceRepository.from_file('test/fixtures/invoices.csv', engine)
    @invoice = Invoice.new(data, "test/fixtures", repo)
  end

  def test_it_exists
    assert invoice
  end

  def test_it_has_an_id
    assert_equal "1", invoice.id
  end

  def test_it_has_a_customer_id
    assert_equal "1", invoice.customer_id
  end

  def test_it_has_a_merchant_id
    assert_equal "26", invoice.merchant_id
  end

  def test_it_has_a_status
    assert_equal "shipped", invoice.status
  end

  def test_it_has_a_create_at_date
    created_at_date = Date.parse("2012-03-25")
    assert_equal created_at_date, invoice.created_at
  end

  def test_it_has_an_updated_at_date
    updated_at_date = Date.parse("2012-03-25")
    assert_equal updated_at_date, invoice.updated_at
  end

  def test_it_has_transactions
    transactions = invoice.transactions
    assert_equal 1, transactions.count
    assert_kind_of Transaction, transactions[0]
  end

  def test_it_has_invoice_items
    invoice_items = invoice.invoice_items
    assert_equal 8, invoice_items.count
    assert_kind_of InvoiceItem, invoice_items[0]
  end

  def test_it_has_items
    items = invoice.items
    assert_equal 2, items.count
    assert_kind_of Item, items[0]
  end

  def test_it_has_a_customer
    customer = invoice.customer
    assert_kind_of Customer, customer
  end

  def test_it_has_a_merchant
    merchant = invoice.merchant
    assert_kind_of Merchant, merchant
  end
end
