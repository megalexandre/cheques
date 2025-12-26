FactoryBot.define do
  factory :bank_holiday do
    date { Date.tomorrow }
  end
end
