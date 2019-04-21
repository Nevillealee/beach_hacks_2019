Rails.application.routes.draw do
  devise_for :users
  resource :dashboard, only: [:show]
  root 'home#index'
  namespace :user do
    resources :uploads, only: [:new, :create, :show, :analyze]
  end
  post "/analyze" => "user/uploads#analyze", :as => :analyze

end
