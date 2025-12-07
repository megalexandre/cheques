class Cheque < ApplicationRecord
  belongs_to :bordero

  monetize :value_cents, as: :value
end
