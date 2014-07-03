require_relative 'test_helper'
require 'bigdecimal'

class ParserTest < Minitest::Test
  attr_reader :invoice_item

  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    @invoice_item = InvoiceItem.new({id: '1', item_id: '539', invoice_id: '1',
      quantity: '5', unit_price: '13635', created_at: '2012-03-27 14:54:09 UTC',
       updated_at: '2012-03-27 14:54:09 UTC'}, "test/fixtures",
       InvoiceItemRepository.from_file('test/fixtures/invoice_items.csv', engine))
  end

  def test_it_converts_to_big_decimal
    big_decimal = BigDecimal.new("1345.24")
    assert_equal big_decimal, invoice_item.decimal("1345.24")
  end

  def test_it_parses_date
    date = Date.parse("2012-03-27")
    assert_equal date, invoice_item.date("2012-03-27")
  end
end
