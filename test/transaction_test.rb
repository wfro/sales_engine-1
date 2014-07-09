require './test/test_helper'
require 'bigdecimal'

class TransactionTest < Minitest::Test
  attr_reader :transaction

  def setup
    engine = SalesEngine.new('./test/fixtures')
    engine.startup("./test/fixtures")
    @transaction = engine.transaction_repository.objects[0]
  end

  def test_it_has_an_id
    assert_equal '1', transaction.id
  end

  def test_it_has_an_invoice_id
    assert_equal '1', transaction.invoice_id
  end

  def test_it_has_a_credit_card_number
    assert_equal '4654405418249632', transaction.credit_card_number
  end

  def test_it_has_a_result
    assert_equal 'success', transaction.result
  end

  def test_it_has_created_at_date
    created_at_date = Date.parse("2012-03-27")
    assert_equal created_at_date, transaction.created_at
  end

  def test_it_has_updated_at_date
    updated_at_date = Date.parse("2012-03-27")
    assert_equal updated_at_date, transaction.updated_at
  end

  def test_it_has_invoices
    invoices = transaction.invoices
    assert_equal 1, invoices.count
    assert_kind_of Invoice, invoices[0]
  end
end
