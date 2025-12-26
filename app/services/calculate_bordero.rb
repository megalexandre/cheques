class CalculateBordero
  def initialize(bordero_data)
    @bordero_data = bordero_data
  end

  def call
    calculated_cheques = @bordero_data[:cheques].map do |cheque|
      ChequeCalculator.new(
        value: cheque[:value],
        due_date: cheque[:due_date],
        processing_days: cheque[:processing_days],
        exchange_date: @bordero_data[:exchange_date],
        monthly_interest: @bordero_data[:monthly_interest]
      ).to_h
    end

    @bordero_data.merge(
      monthly_interest: @bordero_data[:monthly_interest].to_d.round(5),
      total_amount:,
      cheques: calculated_cheques
    )
  end

  private

  def total_amount
    @bordero_data[:cheques].sum { |cheque| cheque[:value] }
  end
end
