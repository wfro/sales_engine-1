require_relative 'test_helper'
require './lib/parser'
require 'bigdecimal'

class InvoiceItemTest < Minitest::Test
  attr_reader :invoice_item

  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    @invoice_item = engine.invoice_item_repository.objects[0]
  end

  def test_it_has_an_id
    assert_equal 1, invoice_item.id
  end

  def test_it_has_an_item_id
    assert_equal 539, invoice_item.item_id
  end

  def test_it_has_an_invoice_id
    assert_equal 1, invoice_item.invoice_id
  end

  def test_it_has_a_quantity
    quant = BigDecimal.new('5')
    assert_equal quant, invoice_item.quantity
  end

  def test_it_has_a_unit_price
    price = BigDecimal.new('13635')
    assert_equal price, invoice_item.unit_price
  end

  def test_it_has_created_at_date
    created_at_date = Date.parse("2012-03-27")
    assert_equal created_at_date, invoice_item.created_at
  end

  def test_it_has_updated_at_date
    updated_at_date = Date.parse("2012-03-27")
    assert_equal updated_at_date, invoice_item.updated_at
  end

  def test_it_has_items
    item = invoice_item.item
    assert_kind_of Item, item
  end

  def test_it_has_invoices
    invoice = invoice_item.invoice
    assert_kind_of Invoice, invoice
  end
end
