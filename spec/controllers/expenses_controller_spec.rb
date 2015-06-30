require "rails_helper"

RSpec.describe ExpensesController, :type => :controller do

  describe "index" do
    it "render index page" do  
      user = FactoryGirl.create(:user)    
      sign_in_as(user) do
        get :index, locale: "en"

        expect(response).to render_template("index")
      end
    end
  end

  describe "create" do
    it "create new expense" do
      user = FactoryGirl.create(:user)    
      sign_in_as(user) do
        expect {
          post :create, locale: "en",
          expense: {
            date: Time.now,
            detail: "Test",
            amount: 80,
            credit: ""
          }
        }.to change(Expense, :count).by(1)

        expect(user.expenses.count).to eq(1)
      end
    end
  end

  describe "delete" do
    it "delete expense" do
      user = FactoryGirl.create(:user)    
      expense = FactoryGirl.create(:expense, user: user)

      sign_in_as(user) do
        expect {
          delete :destroy, id: expense.id, locale: "en"
        }.to change(Expense, :count).by(-1)
      end
    end
  end
  
end