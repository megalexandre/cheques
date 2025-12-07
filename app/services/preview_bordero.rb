class PreviewBordero
  def initialize(bordero_data)
    @bordero_data = bordero_data
  end

  def call
    cheques_calculados = @bordero_data[:cheques].map do | cheque |
      ChequeCalculator.new(
        valor_cheque: cheque[:valor_cheque],
        data_vencimento: cheque[:data_vencimento],
        dias_compensacao: cheque[:dias_compensacao],
        data_troca: @bordero_data[:data_troca],
        juros_mensal: @bordero_data[:juros_mensal]
      ).to_h
    end

    @bordero_data.merge(valor_cheques_total:, cheques: cheques_calculados,)
  end

  private

  def valor_cheques_total
    @bordero_data[:cheques].sum { |cheque| cheque[:valor_cheque] }
  end
end
