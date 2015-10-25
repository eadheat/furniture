Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  scope "/:locale", :locale => /en|th/ do
    resources :expenses do
      member do 
        get :expense_details
      end
    end
    resources :other_expenses do
      member do 
        get :expense_details
      end
    end
    resources :incomes do
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
    resources :contacts do
      collection do
        post :send_contact
      end 
    end

  end

  namespace :api, :format => :json do
    namespace :v1 do
      resources :sessions
      resources :expenses
      resources :expense_summaries
    end
  end

  root to: "expenses#index"
  
end
