require "rails_helper"

RSpec.describe HistoriesController, :type => :controller do

  before(:each) do
    @user = FactoryGirl.create(:user)  
    @expense_last_year = FactoryGirl.create(:expense, 
      date: Time.now - 1.year,
      amount: 200, 
      user: @user
    )
    @expense_last_year_2 = FactoryGirl.create(:expense, 
      date: Time.now - 1.year,
      amount: 400, 
      user: @user
    )
    @expense_current_year = FactoryGirl.create(:expense, 
      date: Time.now, 
      amount: 300,
      user: @user
    )
    @expense_current_year_2 = FactoryGirl.create(:expense, 
      date: Time.now, 
      amount: 600,
      user: @user
    )
  end

  describe "index" do
    it "render index page" do   
      sign_in_as(@user) do
        get :index, locale: :th

        expect(response).to render_template("index")
      end
    end

    it "search with year" do 
      sign_in_as(@user) do
        get :index, year: (Time.now - 1.year).year, locale: :th

        expect(assigns[:year]).to eq((Time.now - 1.year).year)
        expect(assigns[:total_amount].to_i).to eq(600)
        expect(response).to render_template("index")
      end
    end
  end

end