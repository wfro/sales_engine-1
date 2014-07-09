require_relative 'test_helper'

class InvoiceItemRepositoryTest < Minitest::Test
  attr_reader :invoice_item_repo

  def setup
    engine = SalesEngine.new('./test/fixtures')
    engine.startup("./test/fixtures")
    @invoice_item_repo = engine.invoice_item_repository
  end

  def test_it_has_merchants
    assert invoice_item_repo.objects
  end

  def test_it_finds_items
    items = invoice_item_repo.find_items(539)
    assert_equal 1, items.count
    assert_kind_of Item, items[0]
  end

  def test_it_finds_invoices
    invoices = invoice_item_repo.find_invoices(1)
    assert_equal 1, invoices.count
    assert_kind_of Invoice, invoices[0]
  end

  def test_it_finds_by_item_id
    result = invoice_item_repo.find_by_item_id(539)
    assert_equal 1, result.id
  end

  def test_it_finds_all_by_item_id
    result = invoice_item_repo.find_all_by_item_id(539)
    assert_equal 2, result.count
  end

  def test_it_finds_by_quantity
    result = invoice_item_repo.find_by_quantity(BigDecimal.new(6))
    assert_equal 8, result.id
  end

  def test_it_finds_all_by_quantity
    result = invoice_item_repo.find_all_by_quantity(BigDecimal.new(6))
    assert_equal 5, result.count
  end

  def test_it_finds_by_unit_price
    result = invoice_item_repo.find_by_unit_price(BigDecimal.new(23324))
    assert_equal 2, result.id
  end

  def test_it_finds_all_by_unit_price
    result = invoice_item_repo.find_all_by_unit_price(BigDecimal.new(23324))
    assert_equal 2, result.count
  end

  def test_it_finds_by_invoice_id
    result = invoice_item_repo.find_by_invoice_id(2)
    assert_equal 9, result.id
  end

  def test_it_finds_all_by_invoice_id
    result = invoice_item_repo.find_all_by_invoice_id(2)
    assert_equal 1, result.count
  end
end
