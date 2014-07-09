require './test/test_helper'
require 'bigdecimal'
require 'pry'

class ItemTest < Minitest::Test
  attr_reader :item
  def setup
    engine = SalesEngine.new('./test/fixtures')
    engine.startup("./test/fixtures")
    @item = engine.item_repository.objects[0]
  end

  def test_it_exists
    assert item
  end

  def test_it_has_an_id
    assert_equal 1, item.id
  end

  def test_it_has_a_name
    assert_equal 'Item Qui Esse', item.name
  end

  def test_it_has_a_description
    assert_equal 'Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.', item.description
  end

  def test_it_has_a_unit_price
    price = BigDecimal.new("75107")
    assert_equal price, item.unit_price
  end

  def test_it_has_a_merchant_id
    assert_equal 1, item.merchant_id
  end

  def test_it_has_a_created_at_date
    created_at_date = Date.parse("2012-03-27")
    assert_equal created_at_date, item.created_at
  end

  def test_it_has_a_updated_at_date
    updated_at_date = Date.parse("2012-03-27")
    assert_equal updated_at_date, item.updated_at
  end

  def test_it_has_invoice_items
    invoice_items = item.invoice_items
    assert_equal 2, invoice_items.count
    assert_kind_of InvoiceItem, invoice_items[0]
  end

  def test_it_has_a_merchant
    merchant = item.merchant
    assert_kind_of Merchant, merchant
  end

  def business_intelligence
    engine = SalesEngine.new('./test/fixtures/business_intelligence')
    engine.startup('./test/fixtures/business_intelligence')
    @business_intelligence_item1 = engine.item_repository.objects[0]
    @business_intelligence_item2 = engine.item_repository.objects[1]
  end

  def test_it_finds_best_day
    business_intelligence
    date_result1 = @business_intelligence_item1.best_day
    date_result2 = @business_intelligence_item2.best_day

    date1 = Date.parse("2012-03-27")
    date2 = Date.parse("2012-03-14")

    assert_equal date1, date_result1
    assert_equal date2, date_result2
  end
end
