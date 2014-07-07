module Parser
  def decimal(number)
    BigDecimal.new(number)
  end

  def date(unformatted_date)
    Date.parse(unformatted_date.split(" ")[0])
  end

  def dollars(cents)
    number = cents / 100.0
    new_number = sprintf("%.02f", number)
    decimal(new_number)
  end
end
