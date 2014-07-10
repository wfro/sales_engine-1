require_relative './finder'
require_relative './loader'
require_relative './transaction'

class TransactionRepository
  include Finder

  attr_reader   :sales_engine
  attr_accessor :objects
  
  def initialize(filename, engine)
    @sales_engine = engine
    @objects      = Loader.read(filename, Transaction, self).to_a
  end

  def find_invoices(invoice_id)
    sales_engine.find_invoices_by(invoice_id, "id")
  end

  def find_by_invoice_id(invoice_id)
    objects.find {|object| object.invoice_id == invoice_id}
  end

  def find_all_by_invoice_id(invoice_id)
    objects.find_all {|object| object.invoice_id == invoice_id}
  end

  def find_by_credit_card_number(credit_card_number)
    objects.find {|object| object.credit_card_number == credit_card_number}
  end

  def find_all_by_credit_card_number(credit_card_number)
    objects.find_all {|object| object.credit_card_number == credit_card_number}
  end

  def find_by_result(result)
    objects.find {|object| object.result == result}
  end

  def find_all_by_result(result)
    objects.find_all {|object| object.result == result}
  end
end
