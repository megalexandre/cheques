class ChequeCalculator
  attr_reader :value, :due_date, :processing_days, :days_count, :monthly_interest

  def initialize(value:, due_date:, processing_days:, exchange_date:, monthly_interest:)
    @value = Money.new(value.to_d * 100, "BRL")
    @due_date = due_date.is_a?(Date) ? due_date : Date.parse(due_date.to_s)
    @processing_days = processing_days
    @exchange_date = exchange_date.is_a?(Date) ? exchange_date : Date.parse(exchange_date.to_s)
    @monthly_interest = monthly_interest
  end

  def to_h
    {
      value: @value.to_d,
      effective_due_date:,
      due_date: @due_date,
      processing_days: @processing_days,
      days_count:,
      total_interest: total_interest_percentage,
      paid_for_exchange: paid_for_exchange_money.to_d,
      amount_to_receive: amount_to_receive_money.to_d
    }
  end

  private

  def effective_due_date
    target_date = @due_date

    # 1. Garante que a data inicial (vencimento) seja um dia útil
    while weekend?(target_date) || bank_holiday?(target_date)
      target_date += 1
    end

    # 2. Adiciona os dias de processamento, um por um, pulando dias não úteis
    days_to_add = @processing_days
    while days_to_add > 0
      target_date += 1
      # Só decrementa o contador se o novo dia for útil
      unless weekend?(target_date) || bank_holiday?(target_date)
        days_to_add -= 1
      end
    end

    target_date
  end

  def days_count
    (effective_due_date - @exchange_date).to_i
  end

  def weekend?(date)
    date.saturday? || date.sunday?
  end

  def bank_holiday?(date)
    BankHoliday.exists?(date: date)
  end

  def total_interest_percentage
    ((monthly_interest / 30.0) * days_count).round(5)
  end

  def paid_for_exchange_money
    Money.new((@value.to_d * total_interest_percentage / 100.0 * 100).round, "BRL")
  end

  def amount_to_receive_money
    @value - paid_for_exchange_money
  end
end
