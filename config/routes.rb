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
  end
  
  root to: "expenses#index"
end
