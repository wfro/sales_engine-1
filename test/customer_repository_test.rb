require './test/test_helper'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :customer_repo
  def setup
    engine = SalesEngine.new("./test/fixtures")
    engine.startup("./test/fixtures")
    @customer_repo = engine.customer_repository
  end

  def test_it_has_customers
    assert customer_repo.objects
  end

  def test_it_finds_invoices
    invoices = customer_repo.find_invoices(1)
    assert_equal 16, invoices.count
    assert_kind_of Invoice, invoices[0]
  end

  def test_it_finds_by_first_name
    result = customer_repo.find_by_first_name('Joey')
    assert_equal 1, result.id
  end

  def test_it_finds_all_by_first_name
    result = customer_repo.find_all_by_first_name('Joey')
    assert_equal 1, result.count
  end

  def test_it_finds_by_last_name
    result = customer_repo.find_by_last_name('Nader')
    assert_equal 5, result.id
  end

  def test_it_finds_all_by_last_name
    result = customer_repo.find_all_by_last_name('Nader')
    assert_equal 1, result.count
  end

  def business_intelligence
    engine = SalesEngine.new("./test/fixtures/business_intelligence")
    engine.startup("./test/fixtures/business_intelligence")
    @business_intelligence_repo = engine.customer_repository
  end

  def test_it_finds_transactions
    business_intelligence
    transactions = @business_intelligence_repo.find_transactions(1)
    assert_kind_of Transaction, transactions[0]
    assert_equal 1, transactions.count
  end

 def test_it_finds_favorite_merchant
   business_intelligence
   favorite_merchant = @business_intelligence_repo.find_favorite_merchant(1)
   assert_kind_of Merchant, favorite_merchant
   assert_equal "Klein, Rempel and Jones", favorite_merchant.name
 end
end
