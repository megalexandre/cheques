class ChequeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ValidatesFieldFormat

  attribute :value, :decimal
  attribute :due_date, :date
  attribute :processing_days, :integer

  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :due_date, presence: true
  validates :processing_days, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validates_date_format :due_date
  validates_integer_format :processing_days

  # validate :validate_due_date_future

  attr_reader :raw_due_date, :raw_processing_days

  def initialize(params = {})
    @raw_due_date = params[:due_date]
    @raw_processing_days = params[:processing_days]
    super
  end

  def to_h
    {
      value: value,
      due_date: due_date,
      processing_days: processing_days
    }
  end

  private

  def validate_due_date_future
    return if due_date.blank?
    return unless due_date.is_a?(Date)
    return if due_date >= Date.current

    errors.add(:due_date, "must be in the future")
  end
end
