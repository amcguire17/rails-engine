Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find_one'
      resources :merchants, only: [:index, :show]
      get '/merchants/:id/items', to: 'merchant_items#index'
      resources :items, only: [:index, :show, :create, :update, :destroy]
      get '/items/:id/merchant', to: 'item_merchant#show'
    end
  end
end
