class BorderoPreviewForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ValidatesFieldFormat

  attribute :exchange_date, :date
  attribute :monthly_interest, :decimal

  attr_accessor :cheques

  validates :exchange_date, presence: true
  validates :monthly_interest, presence: true, numericality: { greater_than: 0 }

  validates_date_format :exchange_date

  validate :validate_cheques
  validate :validate_cheques_presence
  # validate :validate_exchange_date_future

  PERMITTED_PARAMS = {
    bordero: [ :exchange_date, :monthly_interest ],
    cheques: [ :value, :due_date, :processing_days ]
  }.freeze

  class << self
    def permit_params(params)
      params.permit(
        *PERMITTED_PARAMS[:bordero],
        cheques: PERMITTED_PARAMS[:cheques]
      ).to_h.with_indifferent_access
    end
  end

  def initialize(params = {})
    permitted_params = self.class.permit_params(params)
    @raw_exchange_date = permitted_params[:exchange_date]
    super(permitted_params.except(:cheques))
    @cheques = build_cheques(permitted_params[:cheques] || [])
  end

  def valid?
    super && cheques.all?(&:valid?)
  end

  def to_h
    {
      exchange_date: exchange_date,
      monthly_interest: monthly_interest,
      cheques: cheques.map(&:to_h)
    }
  end

  private

  def build_cheques(cheques_params)
    cheques_params.map { |cheque_params| ChequeForm.new(cheque_params) }
  end

  def validate_cheques
    return if cheques.blank?

    cheques.each_with_index do |cheque, index|
      next if cheque.valid?

      cheque.errors.each do |error|
        errors.add(:base, "Cheque #{index + 1}: #{error.full_message}")
      end
    end
  end

  def validate_cheques_presence
    errors.add(:cheques, "can't be blank") if cheques.blank?
  end

  def validate_exchange_date_future
    return if exchange_date.blank?
    return if exchange_date >= Date.current

    errors.add(:exchange_date, "must be in the future")
  end
end
