require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @time_now = Time.parse("Jul 24 2015")
    allow(Time).to receive(:current).and_return(@time_now)

    @expense = FactoryGirl.create(:expense, date: Time.current.to_date, detail: "Lunch", amount: 80, user: @user) 
    @expense_2 = FactoryGirl.create(:expense, date: (Time.current - 3.days).to_date, detail: "Lunch", amount: 90, user: @user) 
    @expense_3 = FactoryGirl.create(:expense, date: (Time.current - 34.days).to_date, detail: "Lunch", amount: 80, user: @user) 

    @income_expense = FactoryGirl.create(:expense, date: Time.current.to_date, detail: "Lunch", amount: 80, user: @user, income: true)
    @income_expense_2 = FactoryGirl.create(:expense, date: (Time.current - 3.days).to_date, detail: "Lunch", amount: 100, user: @user, income: true)
    @income_expense_3 = FactoryGirl.create(:expense, date: (Time.current - 34.days).to_date, detail: "Lunch", amount: 80, user: @user, income: true)

    @other_expense = FactoryGirl.create(:expense, date: Time.current.to_date, detail: "Lunch", amount: 80, user: @user, other: true)
    @other_expense_2 = FactoryGirl.create(:expense, date: (Time.current - 3.days).to_date, detail: "Lunch", amount: 40, user: @user, other: true)
    @other_expense_3 = FactoryGirl.create(:expense, date: (Time.current - 34.days).to_date, detail: "Lunch", amount: 80, user: @user, other: true)    
  end

  describe "relations" do
    it { should have_many(:expenses) }
    it { should have_many(:events) }
  end

  describe "total_income_of_this_month" do
    it "show total income of this month" do 
      expect(@user.total_income_of_this_month).to eq(180)
    end
  end

  describe "total_of_this_month" do
    it "show total of this month" do 
      expect(@user.total_of_this_month).to eq(170)
      expect(@user.total_of_this_month(other_expense: true)).to eq(120)
    end
  end

  describe "average_of_this_month" do
    it "show total average of this month" do 
      expect(@user.average_of_this_month).to eq(85)
      expect(@user.average_of_this_month(other_expense: true)).to eq(60)
    end
  end

end