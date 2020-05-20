Rails.application.routes.draw do
  namespace :v1 do
    resources :patients
    # root 'patients#index'
  end
end
