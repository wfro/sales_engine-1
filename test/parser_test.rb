require_relative 'test_helper'
require 'bigdecimal'

class ParserTest < Minitest::Test
  attr_reader :invoice_item

  def setup
    engine = SalesEngine.new('./test/fixtures')
    engine.startup("./test/fixtures")
    @invoice_item = engine.invoice_item_repository.objects[0]
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
