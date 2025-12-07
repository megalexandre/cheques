class ApplicationController < ActionController::API
  before_action :set_locale

  private

  def set_locale
    I18n.locale = extract_locale_from_header || I18n.default_locale
  end

  def extract_locale_from_header
    accept_language = request.headers["Accept-Language"]
    return nil unless accept_language

    # Pega o primeiro locale do header Accept-Language
    locale = accept_language.split(",").first&.split("-")&.first&.to_sym
    I18n.available_locales.include?(locale) ? locale : nil
  end
end
