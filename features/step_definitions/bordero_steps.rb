Então('o borderô deve ter {int} cheque(s)') do |quantidade|
  bordero = Bordero.last
  expect(bordero).not_to be_nil
  expect(bordero.cheques.count).to eq(quantidade)
end
