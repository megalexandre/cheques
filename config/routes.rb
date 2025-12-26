Rails.application.routes.draw do
  resources :cheques
  get "bank_holidays/index"
  get "bank_holidays/show"
  get "bank_holidays/create"
  get "bank_holidays/update"
  get "bank_holidays/destroy"
  resources :bank_holidays
  post "borderos" => "borderos#create", as: :create_bordero
  post "borderos/preview" => "borderos#preview", as: :calculate_preview

  get "up" => "rails/health#show", as: :rails_health_check
end
