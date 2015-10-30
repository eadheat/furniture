require "rails_helper"

RSpec.describe Api::V1::ExpensesController, :type => :controller do

  before(:each) do
    @user = FactoryGirl.create(:user)   
    @request.headers['Authorization'] = @user.access_token
  end

  describe "#index" do
    it "render expenses" do  
      expense_1 = FactoryGirl.create(:expense, date: Time.current.to_date, amount: 80, detail: "Breakfast", user: @user)
      other_expense = FactoryGirl.create(:expense, date: Time.current.to_date, amount: 100, detail: "Television", user: @user, other: true)
      expense_3 = FactoryGirl.create(:expense, date: Time.current.to_date, amount: 100, detail: "Lunch", user: @user)
      expense_4 = FactoryGirl.create(:expense, date: Time.current - 2.days, amount: 10000, detail: "Lunch", user: @user)

      get :index

      expect(response.body).to eq(
        {
          status: "OK",
          total_of_today: "180.0",
          daily_total_of_this_month: "10180.0",
          daily_average_of_this_month: "5090.0",
          other_total_of_this_month: "100.0",
          other_average_of_this_month: "50.0",
          total_of_this_month: "10280.0",
          average_of_this_month: "5140.0",
          expenses: Expense.all.order("created_at desc").limit(30).map(&:attributes)
        }.to_json)
    end
  end

  describe "#show" do
    let(:expense) {FactoryGirl.create(:expense, date: Time.current.to_date, amount: 80, detail: "Breakfast", user: @user)}
    let(:expense_2) {FactoryGirl.create(:expense, date: Time.current.to_date, amount: 12000, detail: "Television", user: @user, other: true)}

    it "render expense detail" do
      get :show, id: expense.id

      expect(response.body).to eq(
        {
          status: "OK",
          expense: expense.attributes
        }.to_json)
    end
  end

  describe "#create" do
    let(:expense) {FactoryGirl.create(:expense, date: Time.current.to_date, amount: 80, detail: "Breakfast", user: @user)}
    let(:expense_2) {FactoryGirl.create(:expense, date: Time.current.to_date, amount: 12000, detail: "Television", user: @user, other: true)}

    it "create new daily expense" do
      expect {
        post :create, expense_type: "expense", expense: {
          date: "29.10.2015",
          detail: "Dinner",
          amount: 720
        }
      }.to change(Expense, :count).by(1)

      last_expense = Expense.last

      expect(last_expense.other).to eq(false)
      expect(last_expense.date).to eq("29.10.2015".to_date)
      expect(last_expense.detail).to eq("Dinner")
      expect(last_expense.amount).to eq(720)
      expect(response.body).to eq({
          status: "OK",
          expense: last_expense.attributes
        }.to_json)
    end

    it "create new other expesnse" do
      expect {
        post :create, expense_type: "other_expense", expense: {
          date: "29.10.2015",
          detail: "Mobile Phone",
          amount: 24900
        }
      }.to change(Expense, :count).by(1)

      last_expense = Expense.last

      expect(last_expense.other).to eq(true)
      expect(last_expense.date).to eq("29.10.2015".to_date)
      expect(last_expense.detail).to eq("Mobile Phone")
      expect(last_expense.amount).to eq(24900)
      expect(response.body).to eq({
          status: "OK",
          expense: last_expense.attributes
        }.to_json)
    end
  end

  describe "#update" do
    let(:expense) {FactoryGirl.create(:expense, date: Time.current.to_date, amount: 80, detail: "Breakfast", user: @user)}
    let(:expense_2) {FactoryGirl.create(:expense, date: Time.current.to_date, amount: 12000, detail: "Television", user: @user, other: true)}

    it "update expense" do
      put :update, id: expense.id, expense: {detail: "First Breakfast", amount: 100}

      expect(expense.reload.detail).to eq("First Breakfast")
      expect(expense.reload.amount).to eq(100)

      expect(response.body).to eq({
          status: "OK",
          expense: expense.attributes
        }.to_json)
    end
  end

  describe "#destroy" do
    it "delete expense" do
      expense = FactoryGirl.create(:expense, date: Time.current.to_date, amount: 80, detail: "Breakfast", user: @user)
      expense_2 = FactoryGirl.create(:expense, date: Time.current.to_date, amount: 80, detail: "Breakfast", user: @user, other: true)

      delete :destroy, id: expense.id

      expect(Expense.all.count).to eq(1)
      expect(response.body).to eq({
          status: "OK"
        }.to_json)
    end
  end
end