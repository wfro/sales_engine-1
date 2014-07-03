require './test/test_helper'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :customer_repo
  def setup
    engine = SalesEngine.new
    engine.startup("./test/fixtures")
    @customer_repo = CustomerRepository.from_file('./test/fixtures/customers.csv', engine)
  end

  def test_it_has_customers
    assert customer_repo.objects
  end

  def test_it_finds_invoices
    invoices = customer_repo.find_invoices("1")
    assert_equal 16, invoices.count
    assert_kind_of Invoice, invoices[0]
  end

  def test_it_finds_by_first_name
    result = customer_repo.find_by_first_name('Joey')
    assert_equal '1', result.id
  end

  def test_it_finds_all_by_first_name
    result = customer_repo.find_all_by_first_name('Joey')
    assert_equal 1, result.count
  end

  def test_it_finds_by_last_name
    result = customer_repo.find_by_last_name('Nader')
    assert_equal '5', result.id
  end

  def test_it_finds_all_by_last_name
    result = customer_repo.find_all_by_last_name('Nader')
    assert_equal 1, result.count
  end
end
