require_relative './test_helper'
require './lib/loader'
require 'csv'

class LoaderTest < Minitest::Test
  attr_reader :loader
  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    @loader = Loader.read('test/fixtures/merchants.csv', Merchant, engine.merchant_repository)
  end

  def test_it_exists
    assert loader
  end

  def test_it_loads_data
    results = loader[0]
    assert_equal 'Schroeder-Jerde', results.name

    results = loader[1]
    assert_equal '2', results.id

    results = loader[2]
    created_at_date = Date.parse("2012-03-27")
    assert_equal created_at_date, results.created_at

    results = loader[3]
    updated_at_date = Date.parse("2012-03-27")
    assert_equal updated_at_date, results.updated_at
  end
end
