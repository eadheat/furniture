Rails.application.routes.draw do
  devise_for :users

  scope "/:locale" do
    resources :expenses do
      member do 
        get :expense_details
      end
    end
    resources :histories
    resources :details
    resources :summaries
    resources :notes do
      collection do
        get :event
      end
    end
  end
  
  root to: "expenses#index"
end
