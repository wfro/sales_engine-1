require './test/test_helper'
require 'bigdecimal'

class MerchantTest < Minitest::Test
  attr_reader :merchant

  def setup
    engine = SalesEngine.new
    engine.startup('./test/fixtures')
    @merchant = Merchant.new({id: "1", name: "Schroeder-Jerde", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC"}, "test/fixtures", engine.merchant_repository)
  end

  def test_it_exists
    assert merchant
  end

  def test_it_has_an_id
    assert_equal "1", merchant.id
  end

  def test_it_has_a_name
    assert_equal "Schroeder-Jerde", merchant.name
  end

  def test_it_has_a_created_at_date
    created_at_date = Date.parse("2012-03-27")
    assert_equal created_at_date, merchant.created_at
  end

  def test_it_has_an_updated_at_date
    updated_at_date = Date.parse("2012-03-27")
    assert_equal updated_at_date, merchant.updated_at
  end

  def test_it_has_items
    items = merchant.items
    assert_equal 12, items.count
    assert_kind_of Item, items[1]
  end

  def test_it_has_invoices
    invoices = merchant.invoices
    assert_equal 1, invoices.count
    assert_kind_of Invoice, invoices[0]
  end

  def business_intelligence
    engine = SalesEngine.new
    engine.startup('./test/fixtures/business_intelligence')
    @business_intelligence_merchant = Merchant.new({id: "2", name: "Klein, Rempel and Jones", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC"}, "test/fixtures", engine.merchant_repository)
  end

  def test_it_has_revenue
    business_intelligence
    revenue = @business_intelligence_merchant.revenue
    assert_equal BigDecimal.new("681.75"), revenue
  end

  def test_it_finds_revenue_by_date
    business_intelligence
    date = Date.parse("2012-03-27")
    revenue = @business_intelligence_merchant.revenue(date)

    assert_equal BigDecimal.new("681.75"), revenue
  end

  def test_it_finds_favorite_customer
    business_intelligence
    customer = @business_intelligence_merchant.favorite_customer
    assert_equal "Joey", customer.first_name
  end

  def test_it_finds_customers_with_pending_invoices
    business_intelligence
    customers = @business_intelligence_merchant.customers_with_pending_invoices
    assert_equal "Joey", customers[0].first_name
  end
end
