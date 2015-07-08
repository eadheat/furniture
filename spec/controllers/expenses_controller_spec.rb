require "rails_helper"

RSpec.describe ExpensesController, :type => :controller do

  describe "index" do
    it "render index page" do  
      user = FactoryGirl.create(:user)    
      sign_in_as(user) do
        get :index

        expect(response).to render_template("index")
      end
    end
  end

  describe "create" do
    it "create new expense" do
      user = FactoryGirl.create(:user)  
      date = Time.now  
      sign_in_as(user) do
        expect {
          post :create,
          expense: {
            date: date,
            detail: "Test",
            amount: 80,
            credit: ""
          }
        }.to change(Expense, :count).by(1)

        expect(user.expenses.count).to eq(1)

        expect(user.expenses.first.date.to_date).to eq(date.to_date)
        expect(user.expenses.first.detail).to eq("Test")
        expect(user.expenses.first.amount).to eq(80)
        expect(user.expenses.first.credit).to eq(false)
      end
    end
  end

  describe "update" do
    it "update expense" do
      user = FactoryGirl.create(:user)    
      expense = FactoryGirl.create(:expense, date: Time.now - 3.days, detail: "Lunch", amount: 80, credit: false, user: user)
      date = Time.now

      sign_in_as(user) do
        expect {
          put :update, id: expense.id,
          expense: {
            date: date,
            detail: "Test",
            amount: 100,
            credit: "true"
          }
        }.to change(Expense, :count).by(0)

        expense.reload
        expect(user.expenses.first.date.to_date).to eq(date.to_date)
        expect(expense.detail).to eq("Test")
        expect(expense.amount).to eq(100)
        expect(expense.credit).to eq(true)
      end
    end
  end

  describe "expense_details" do
    it "get expense details" do
      user = FactoryGirl.create(:user)    
      expense = FactoryGirl.create(:expense, date: Time.now - 3.days, detail: "Lunch", amount: 80, credit: false, user: user)

      sign_in_as(user) do
        get :expense_details, id: expense.id

        expect(response.body).to eq(
          {
            date: expense.date.strftime("%d %B"),
            detail: expense.detail,
            amount: expense.amount,
            credit: expense.credit ? "<span class='credit'>Credit</span>" : "Cash"
          }.to_json
        )
      end
    end
  end

  describe "delete" do
    it "delete expense" do
      user = FactoryGirl.create(:user)    
      expense = FactoryGirl.create(:expense, user: user)

      sign_in_as(user) do
        expect {
          delete :destroy, id: expense.id
        }.to change(Expense, :count).by(-1)
      end
    end
  end
  
end