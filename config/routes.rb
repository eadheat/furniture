Rails.application.routes.draw do
  devise_for :users
  resources :expenses do
    member do 
      get :expense_details
    end
  end
  resources :histories
  resources :details
  resources :summaries

  root to: "expenses#index"
end
