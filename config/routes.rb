Rails.application.routes.draw do
  post "borderos" => "borderos#create", as: :create_bordero
  post "borderos/preview" => "borderos#preview", as: :calculate_preview

  get "up" => "rails/health#show", as: :rails_health_check
end
