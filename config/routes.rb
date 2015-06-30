Rails.application.routes.draw do
  devise_for :users
    resources  :homes
    resources :expenses

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end
  root to: "homes#index"
end
