class Bordero < ApplicationRecord
  has_many :cheques, dependent: :destroy

  accepts_nested_attributes_for :cheques

  validates :exchange_date, presence: true
  validates :monthly_interest, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
