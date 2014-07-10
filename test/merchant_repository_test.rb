require './test/test_helper'
require 'bigdecimal'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :merchant_repo

  def setup
    engine = SalesEngine.new
    engine.startup('./test/fixtures')
    @merchant_repo = engine.merchant_repository
  end

  def test_it_has_merchants
    assert merchant_repo.objects
  end

  def test_it_finds_items
    items = merchant_repo.find_items(1)
    assert_equal 12, items.count
    assert_kind_of Item, items[1]
  end

  def test_it_finds_invoices
    invoices = merchant_repo.find_invoices(1)
    assert_equal 1, invoices.count
    assert_kind_of Invoice, invoices[0]
  end

  def test_it_finds_by_name
    result = merchant_repo.find_by_name('Bernhard-Johns')
    assert_equal 7, result.id
  end

  def test_it_finds_all_by_name
    result = merchant_repo.find_all_by_name('Bernhard-Johns')
    assert_equal 2, result.count
  end

  def business_intelligence_repo
    engine = SalesEngine.new
    engine.startup('./test/fixtures/business_intelligence')
    most_items_merchant_repo = engine.merchant_repository
  end

  def test_it_finds_merchants_by_highest_revenue
    result = business_intelligence_repo.most_revenue(2)

    assert_equal 2, result.count
    assert_kind_of Merchant, result[0]
    assert result[0].stored_revenue > result[1].stored_revenue
  end

  def test_it_finds_merchants_by_most_items
    result = business_intelligence_repo.most_items(2)

    assert_equal 2, result.count
    assert_kind_of Merchant, result[0]
    assert result[0].items_sold > result[1].items_sold
  end

  def test_it_finds_revenue_by_date
    date = Date.parse("2012-03-27")
    revenue = business_intelligence_repo.revenue(date)

    assert_equal BigDecimal.new("681.75"), revenue
  end

  def test_it_finds_favorite_customer
    merchant = business_intelligence_repo.objects[0]
    customer = business_intelligence_repo.find_favorite_customer(merchant)
    assert_equal "Joey", customer.first_name
  end

  def test_it_finds_customers_with_pending_invoices
    merchant = business_intelligence_repo.objects[0]
    customers = business_intelligence_repo.find_customers_with_pending_invoices(merchant)
    assert_equal "Joey", customers[0].first_name
  end
end
