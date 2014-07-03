require './test/test_helper'
require 'csv'
require './lib/finder'
require './test/support/everything'

class FinderTest < Minitest::Test
  attr_reader :objects
  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    @objects = EverythingRepository.from_file('./test/fixtures/everything.csv', engine)
  end

  def test_it_finds_a_random_object
    random_objects = 100.times.map{objects.random}.uniq
    assert random_objects.length > 1
  end

  def test_it_finds_by_id
    result = objects.find_by_id('6')
    assert_equal 'Bernhard-Johns', result.name
  end

  def test_it_finds_by_created_at
    result = objects.find_by_created_at('2012-03-27 14:54:10 UTC')
    assert_equal '3', result.id
  end

  def test_it_finds_all_by_created_at
    result = objects.find_all_by_created_at('2012-03-27 14:54:10 UTC')
    assert_equal 7, result.count
  end

  def test_it_finds_by_updated_at
    result = objects.find_by_updated_at('2012-03-27 14:54:10 UTC')
    assert_equal '3', result.id
  end

  def test_it_finds_all_by_updated_at
    result = objects.find_all_by_updated_at('2012-03-27 14:54:10 UTC')
    assert_equal 7, result.count
  end
end
