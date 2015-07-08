Rails.application.routes.draw do
  devise_for :users
    resources  :homes
    resources :expenses do
      member do 
        get :expense_details
      end
    end

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
