Rails.application.routes.draw do
  resources :sales do
    get :mpg, on: :collection
    get :period, on: :collection
  end
  resources :items do
    patch :checkout, on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
