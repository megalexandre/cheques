class CalculateBordero
  def initialize(bordero_data)
    @bordero_data = bordero_data
  end

  def call
    @bordero_data.merge(
      monthly_interest:,
      total_paid:,
      total_value:,
      cheques:,
    )
  end

  private

  def monthly_interest
    @bordero_data[:monthly_interest].to_d.round(5)
  end

  def cheques
    @cheques ||= @bordero_data[:cheques].map do |cheque|
      ChequeCalculator.new(
        value: cheque[:value],
        due_date: cheque[:due_date],
        processing_days: cheque[:processing_days],
        exchange_date: @bordero_data[:exchange_date],
        monthly_interest:,
      ).to_h
    end
  end

  def total_paid
    cheques.sum { |cheque| cheque[:value] }
  end

  def total_value
    cheques.sum { |cheque| cheque[:amount_to_receive] }
  end
end
