require './test/test_helper'

class CustomerTest < Minitest::Test
  attr_reader :customer
  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    @customer = engine.customer_repository.objects[0]
  end

  def test_it_exists
    assert customer
  end

  def test_it_has_an_id
    assert_equal "1", customer.id
  end

  def test_it_has_a_first_name
    assert_equal "Joey", customer.first_name
  end

  def test_it_has_a_last_name
    assert_equal "Ondricka", customer.last_name
  end

  def test_it_has_a_created_at_date
    created_at_date = Date.parse("2012-03-27")
    assert_equal created_at_date, customer.created_at
  end

  def test_it_has_an_updated_at_date
    updated_at_date = Date.parse("2012-03-27")
    assert_equal updated_at_date, customer.updated_at
  end

  def test_it_has_invoices
    invoices = customer.invoices
    assert_equal 16, invoices.count
    assert_kind_of Invoice, invoices[0]
  end

  def business_intelligence
    engine = SalesEngine.new
    engine.startup("./test/fixtures/business_intelligence")
    @business_intelligence_customer = engine.customer_repository.objects[0]
  end

  def test_it_finds_transactions
   business_intelligence
   transactions = @business_intelligence_customer.transactions
   assert_kind_of Transaction, transactions[0]
   assert_equal 1, transactions.count
 end

 def test_it_finds_favorite_merchant
   skip
   business_intelligence
   favorite_merchant = @business_intelligence_customer.favorite_merchant
   assert_kind_of Merchant, favorite_merchant[0]
   assert_equal "Willms and Sons", favorite_merchant.name
 end
end
