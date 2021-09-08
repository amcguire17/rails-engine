Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find_one'
      get '/merchants/find_all', to: 'merchants#find_all'
      get '/merchants/most_items', to: 'merchants#quantity_items'
      resources :merchants, only: [:index, :show]
      get '/merchants/:id/items', to: 'merchant_items#index'
      get '/items/find', to: 'items#find_one'
      get '/items/find_all', to: 'items#find_all'
      resources :items, only: [:index, :show, :create, :update, :destroy]
      get '/items/:id/merchant', to: 'item_merchant#show'
      get '/revenue/merchants', to: 'revenue#quantity_merchants'
      get '/revenue/items', to: 'revenue#quantity_items'
      get '/revenue/merchants/:id', to: 'revenue#revenue_merchant'
      get '/revenue', to: 'revenue#revenue_date'
    end
  end
end
