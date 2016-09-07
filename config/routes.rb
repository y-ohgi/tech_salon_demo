Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'top#index'
  resources :users
  resources :like_items
  resources :like_brands
  resources :brands
  resources :items

end
