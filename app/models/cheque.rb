class Cheque < ApplicationRecord
  belongs_to :bordero

  monetize :value, as: :amount
end
