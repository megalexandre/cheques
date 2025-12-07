class BorderoPreviewForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :exchange_date, :date
  attribute :monthly_interest, :decimal

  attr_accessor :cheques

  validates :exchange_date, presence: true
  validates :monthly_interest, presence: true, numericality: { greater_than: 0 }
  validate :validate_cheques
  validate :validate_exchange_date_format
  validate :validate_cheques_presence

  def initialize(params = {})
    permitted_params = permit_params(params)
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

  def permit_params(params)
    params.permit(
      :exchange_date,
      :monthly_interest,
      cheques: [
        :value,
        :due_date,
        :processing_days
      ]
    ).to_h.with_indifferent_access
  end

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

  def validate_exchange_date_format
    return if @raw_exchange_date.blank?
    return if exchange_date.present? # Se foi parseado com sucesso, é válido

    errors.add(:exchange_date, "is not a valid date")
  end

  def validate_cheques_presence
    errors.add(:cheques, "can't be blank") if cheques.blank?
  end

  class ChequeForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :value, :decimal
    attribute :due_date, :date
    attribute :processing_days, :integer

    validates :value, presence: true, numericality: { greater_than: 0 }
    validates :due_date, presence: true
    validates :processing_days, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validate :validate_due_date_format
    validate :validate_processing_days_format

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

    def validate_due_date_format
      return if @raw_due_date.blank?
      return if due_date.present? # Se foi parseado com sucesso, é válido

      errors.add(:due_date, "is not a valid date")
    end

    def validate_processing_days_format
      return if @raw_processing_days.blank?
      return if @raw_processing_days.is_a?(Integer)

      # Se é string, verifica se pode ser convertida para inteiro válido
      if @raw_processing_days.is_a?(String) && @raw_processing_days.match?(/\A-?\d+\z/)
        return # String numérica válida
      end

      # Se chegou aqui, não é um número válido
      errors.add(:processing_days, "is not a number") if processing_days.to_i == 0 && @raw_processing_days != "0"
    end
  end
end
