Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  scope "/:locale", :locale => /en|th/ do
    resources :expenses do
      member do 
        get :expense_details
      end
    end
    resources :histories
    resources :details
    resources :summaries
    resources :events do
      collection do
        get :event
        post :add_event
      end
    end

    root to: "expenses#index"
  end 
  
end
