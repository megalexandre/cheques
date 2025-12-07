Então('o borderô deve ter {int} cheque(s)') do |quantidade|
  bordero = Bordero.last
  expect(bordero).not_to be_nil
  expect(bordero.cheques.count).to eq(quantidade)
end

Então('o total do bordero deve ser {float}') do |total_esperado|
  expect(@json_response['valor_cheques_total']).to eq(total_esperado)
end

Então('o total pago pela troca deve ser {float}') do |total_esperado|
  total_pago = @json_response['cheques'].sum { |cheque| cheque['pago_pela_troca'] }
  expect(total_pago).to eq(total_esperado)
end
