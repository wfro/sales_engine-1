class TransactionRepository
  include Finder

  def self.from_file(filename='./data/transactions.csv', engine)
    transactions = Loader.read(filename, Transaction, self)
    new(transactions, engine)
  end

  attr_reader :objects, :sales_engine
  def initialize(transactions, engine)
    @objects      = transactions
    @sales_engine = engine
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
