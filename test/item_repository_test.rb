require './test/test_helper'

class ItemRepositoryTest < Minitest::Test
  attr_reader :item_repo
  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    @item_repo = ItemRepository.from_file('./test/fixtures/items.csv', engine)
  end

  def test_it_has_items
    assert item_repo.objects
  end

  def test_it_finds_invoice_items
    invoice_items = item_repo.find_invoice_items("1")
    assert_equal 1, invoice_items.count
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
    result = item_repo.find_by_unit_price('75107')
    assert_equal '1', result.id
  end

  def test_it_finds_all_by_unit_price
    result = item_repo.find_all_by_unit_price('75107')
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
end
