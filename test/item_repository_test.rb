require './test/test_helper'
require 'bigdecimal'
require 'pry'

class ItemRepositoryTest < Minitest::Test
  attr_reader :item_repo
  def setup
    engine = SalesEngine.new('./test/fixtures')
    engine.startup("./test/fixtures")
    @item_repo = engine.item_repository
  end

  def test_it_has_items
    assert item_repo.objects
  end

  def test_it_finds_invoice_items
    invoice_items = item_repo.find_invoice_items("1")
    assert_equal 2, invoice_items.count
    assert_kind_of InvoiceItem, invoice_items[0]
  end

  def test_it_finds_merchant
    merchant = item_repo.find_merchant("1")
    assert_kind_of Merchant, merchant
  end

  def test_it_finds_by_name
    result = item_repo.find_by_name('Item Quidem Suscipit')
    assert_equal '10', result.id
  end

  def test_it_finds_all_by_name
    result = item_repo.find_all_by_name('Item Quidem Suscipit')
    assert_equal 3, result.count
  end

  def test_it_finds_by_unit_price
    result = item_repo.find_by_unit_price(BigDecimal.new('75107'))
    assert_equal '1', result.id
  end

  def test_it_finds_all_by_unit_price
    result = item_repo.find_all_by_unit_price(BigDecimal.new('75107'))
    assert_equal 1, result.count
  end

  def test_it_finds_by_merchant_id
    result = item_repo.find_by_merchant_id('1')
    assert_equal '1', result.id
  end

  def test_it_finds_all_by_merchant_id
    result = item_repo.find_all_by_merchant_id('1')
    assert_equal 12, result.count
  end

  def business_intelligence
    engine = SalesEngine.new("./test/fixtures/business_intelligence")
    engine.startup("./test/fixtures/business_intelligence")
    @business_intelligence_repo = engine.item_repository
  end

  def test_it_finds_items_with_most_revenue_generated
    business_intelligence
    results = @business_intelligence_repo.most_revenue(2)
    # binding.pry

    assert_equal 2, results.count
    assert results[0].revenue_generated > results[1].revenue_generated
  end

  def test_it_finds_most_items_sold
    business_intelligence
    results = @business_intelligence_repo.most_items(2)
    # binding.pry

    assert_equal 2, results.count
    assert results[0].number_sold > results[1].number_sold
  end

  def test_it_finds_best_day
    business_intelligence
    item1 = @business_intelligence_repo.objects[0]
    item2 = @business_intelligence_repo.objects[1]

    date_result1 = @business_intelligence_repo.find_best_day(item1)
    date_result2 = @business_intelligence_repo.find_best_day(item2)

    date1 = Date.parse("2012-03-27")
    date2 = Date.parse("2012-03-14")

    assert_equal date1, date_result1
    assert_equal date2, date_result2
  end
end
