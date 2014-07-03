module Parser
  def decimal(number)
    BigDecimal.new(number)
  end

  def date(unformatted_date)
    Date.parse(unformatted_date.split(" ")[0])
  end
end
