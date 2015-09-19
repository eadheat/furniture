require "rails_helper"

RSpec.describe DetailsController, :type => :controller do

  before(:each) do
    @user = FactoryGirl.create(:user)   
  end

  describe "index" do
    it "render index page" do 
      sign_in_as(@user) do
        get :index, month: "#{Time.current.month}", year: "#{Time.current.year}", locale: :th

        expect(response).to render_template("index")
      end
    end

    it "total amount and average" do
      @time_now = Time.parse("Jul 24 2015")
      allow(Time).to receive(:now).and_return(@time_now)

      expense = FactoryGirl.create(:expense, 
        date: Time.current - 5.days, 
        detail: "Breakfast", 
        amount: 125, 
        user: @user
      )
      expense_2 = FactoryGirl.create(:expense, 
        date: Time.current - 7.days, 
        detail: "Breakfast", 
        amount: 450, 
        user: @user
      )
      expense_3 = FactoryGirl.create(:expense, 
        date: Time.current - 10.days, 
        detail: "Breakfast", 
        amount: 300, 
        user: @user
      )

      expense_4 = FactoryGirl.create(:expense, 
        date: Time.current - 1.month, 
        detail: "Breakfast", 
        amount: 230, 
        user: @user
      ) #noise

      sign_in_as(@user) do
        get :index, month: "#{Time.current.month}", year: "#{Time.current.year}", locale: :th

        expect(assigns[:paid_for_month].count).to eq(3) 
        expect(assigns[:total]).to eq(875) 
        expect(assigns[:average]).to eq(291.67)

        expect(response).to render_template("index")
      end
    end

    it "total amount and average in last month" do
      @time_now = Time.parse("Jul 24 2015")
      allow(Time).to receive(:now).and_return(@time_now)

      expense = FactoryGirl.create(:expense, 
        date: Time.current - 5.days, 
        detail: "Breakfast", 
        amount: 125, 
        user: @user
      ) #noise
      expense_2 = FactoryGirl.create(:expense, 
        date: Time.current - 26.days, 
        detail: "Breakfast", 
        amount: 450, 
        user: @user
      )
      expense_3 = FactoryGirl.create(:expense, 
        date: Time.current - 26.days, 
        detail: "Breakfast", 
        amount: 300, 
        user: @user
      )

      expense_4 = FactoryGirl.create(:expense, 
        date: Time.current - 1.month, 
        detail: "Breakfast", 
        amount: 230, 
        user: @user
      ) 

      sign_in_as(@user) do
        get :index, month: (Time.current - 1.month).month, year: "#{Time.current.year}", locale: :th

        expect(assigns[:paid_for_month].count).to eq(3) 
        expect(assigns[:total]).to eq(980) 
        expect(assigns[:average]).to eq(490)

        expect(response).to render_template("index")
      end
    end

    it "wrong month and year should return current time" do
      @time_now = Time.parse("Jul 24 2015")
      allow(Time).to receive(:now).and_return(@time_now)

      expense = FactoryGirl.create(:expense, 
        date: Time.current - 5.days, 
        detail: "Breakfast", 
        amount: 125, 
        user: @user
      )
      expense_2 = FactoryGirl.create(:expense, 
        date: Time.current - 7.days, 
        detail: "Breakfast", 
        amount: 450, 
        user: @user
      )
      expense_3 = FactoryGirl.create(:expense, 
        date: Time.current - 1.month, 
        detail: "Breakfast", 
        amount: 300, 
        user: @user
      )

      expense_4 = FactoryGirl.create(:expense, 
        date: Time.current - 1.month, 
        detail: "Breakfast", 
        amount: 230, 
        user: @user
      ) #noise

      sign_in_as(@user) do
        get :index, month: "45", year: "45674ss", locale: :th

        expect(assigns[:paid_for_month].count).to eq(2) 
        expect(assigns[:total]).to eq(575) 
        expect(assigns[:average]).to eq(287.5)

        expect(response).to render_template("index")
      end
    end
  end
end