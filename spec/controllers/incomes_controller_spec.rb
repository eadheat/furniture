require "rails_helper"

RSpec.describe IncomesController, :type => :controller do

  describe "index" do
    it "render index page" do  
      user = FactoryGirl.create(:user)  
      expense = FactoryGirl.create(:expense, date: (Time.current).to_date, detail: "Lunch", amount: 80, credit: false, user: user, income: true) 
      expense_2 = FactoryGirl.create(:expense, date: (Time.current).to_date, detail: "Lunch", amount: 80, credit: false, user: user) #noise   
      sign_in_as(user) do
        get :index, locale: :en

        expect(response).to render_template("index")
        expect(assigns[:expenses].count).to eq(1)  
        expect(assigns[:expenses]).to include(expense)
      end
    end
  end

  describe "create" do
    it "create new income" do
      user = FactoryGirl.create(:user) 
      expense = FactoryGirl.create(:expense, date: (Time.current).to_date, detail: "Lunch", amount: 80, credit: false, user: user, income: true) 
      expense_2 = FactoryGirl.create(:expense, date: (Time.current).to_date, detail: "Lunch", amount: 80, credit: false, user: user) #noise 
      date = Time.current  

      sign_in_as(user) do
        expect {
          post :create,
          expense: {
            date: date,
            detail: "Test",
            amount: 80,
            income: true
          }, locale: :en
        }.to change(Expense, :count).by(1)

        expect(user.expenses.incomes.count).to eq(2)
        expect(user.expenses.last.date.to_date).to eq(date.to_date)
        expect(user.expenses.last.detail).to eq("Test")
        expect(user.expenses.last.amount).to eq(80)
        expect(user.expenses.last.credit).to eq(false)
        expect(user.expenses.last.income).to eq(true)

        expect(assigns[:total_of_this_month]).to eq(160)
      end
    end
  end

  describe "update" do
    it "update expense" do
      user = FactoryGirl.create(:user)    
      expense = FactoryGirl.create(:expense, date: (Time.current - 3.days).to_date, detail: "Lunch", amount: 80, credit: false, user: user, income: true)
      date = Time.current

      sign_in_as(user) do
        expect {
          put :update, id: expense.id,
          expense: {
            date: expense.date,
            detail: "Test",
            amount: 100
          }, locale: :en
        }.to change(Expense, :count).by(0)

        expense.reload
        expect(expense.detail).to eq("Test")
        expect(expense.amount).to eq(100)
        expect(expense.credit).to eq(false)
        expect(expense.income).to eq(true)

        expect(response.body).to eq({
          date: expense.date.strftime("%d.%m.%Y"),
          detail: expense.detail,
          amount: expense.amount,
          total_for_today: 0,
          total_of_this_month: user.total_income_of_this_month,
          average_of_this_month: 0
        }.to_json)
      end
    end

    it "update expense and update total money of this month" do
      user = FactoryGirl.create(:user)    
      expense = FactoryGirl.create(:expense, date: Time.current.to_date, detail: "Lunch", amount: 80, credit: false, user: user, income: true)
      expense_2 = FactoryGirl.create(:expense, date: Time.current.to_date, detail: "Lunch", amount: 80, credit: false, user: user, income: true)
      expense_3 = FactoryGirl.create(:expense, date: Time.current.to_date, detail: "Lunch", amount: 80, credit: false, user: user) # noise
      date = Time.current.to_date

      sign_in_as(user) do
        expect {
          put :update, id: expense.id,
          expense: {
            date: date,
            detail: "Test",
            amount: 100
          }, locale: :en
        }.to change(Expense, :count).by(0)

        expense.reload
        expect(user.expenses.first.date.to_date).to eq(date.to_date)
        expect(expense.detail).to eq("Test")
        expect(expense.amount).to eq(100)
        expect(expense.credit).to eq(false)
        expect(expense.income).to eq(true)

        expect(response.body).to eq({
          date: expense.date.strftime("%d.%m.%Y"),
          detail: expense.detail,
          amount: expense.amount,
          total_for_today: 0,
          total_of_this_month: user.total_income_of_this_month,
          average_of_this_month: 0
        }.to_json)
      end
    end
  end

  describe "expense_details" do
    it "get expense details" do
      user = FactoryGirl.create(:user)    
      expense = FactoryGirl.create(:expense, date: (Time.current - 3.days).to_date, detail: "Lunch", amount: 80, credit: false, user: user, income: true)

      sign_in_as(user) do
        get :expense_details, id: expense.id, locale: :en

        expect(response.body).to eq(
          {
            date: expense.date.strftime("%d.%m.%Y"),
            detail: expense.detail,
            amount: expense.amount
          }.to_json
        )
      end
    end
  end

  describe "delete" do
    it "delete expense" do
      user = FactoryGirl.create(:user)    
      expense = FactoryGirl.create(:expense, date: Time.current.to_date, amount: 80, user: user, income: true)
      expense_2 = FactoryGirl.create(:expense, date: Time.current.to_date, amount: 100, user: user)
      expense_3 = FactoryGirl.create(:expense, date: Time.current.to_date, amount: 100, user: user)

      sign_in_as(user) do
        expect {
          delete :destroy, id: expense.id, locale: :en
        }.to change(Expense, :count).by(-1)

        expect(response.body).to eq({
          success: true, 
          total_for_today: 0,
          total_of_this_month: user.total_income_of_this_month,
          average_of_this_month: 0
        }.to_json)
      end
    end
  end
  
end