require_relative 'test_helper'

class TransactionRepositoryTest < Minitest::Test
  attr_reader :transaction_repo

  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    @transaction_repo = engine.transaction_repository
  end

  def test_it_has_transactions
    assert transaction_repo.objects
  end

  def test_it_has_invoices
    invoices = transaction_repo.find_invoices(1)
    assert_equal 1, invoices.count
    assert_kind_of Invoice, invoices[0]
  end

  def test_it_finds_by_invoice_id
    result = transaction_repo.find_by_invoice_id(5)
    assert_equal 4, result.id
  end

  def test_it_finds_all_by_invoice_id
    result = transaction_repo.find_all_by_invoice_id(5)
    assert_equal 1, result.count
  end

  def test_it_finds_by_credit_card_number
    result = transaction_repo.find_by_credit_card_number('4801647818676136')
    assert_equal 7, result.id
  end

  def test_it_finds_all_by_credit_card_number
    result = transaction_repo.find_all_by_credit_card_number('4801647818676136')
    assert_equal 1, result.count
  end

  def test_it_finds_by_result
    result = transaction_repo.find_by_result('success')
    assert_equal 1, result.id
  end

  def test_it_finds_all_by_result
    result = transaction_repo.find_all_by_result('success')
    assert_equal 9, result.count
  end
end
