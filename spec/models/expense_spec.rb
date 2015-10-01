require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe "relations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:detail) }
    it { should validate_presence_of(:amount) }
  end

  describe "scopes" do
    describe "my_expenses" do
      it "return expenses other = false and income = false" do
        user = FactoryGirl.create(:user)
        expense = FactoryGirl.create(:expense, user: user, other: true) # noise
        expense_2 = FactoryGirl.create(:expense, user: user, income: true) # noise
        expense_3 = FactoryGirl.create(:expense, user: user)
        expense_4 = FactoryGirl.create(:expense, user: user)

        result_expenses = user.expenses.my_expenses

        expect(result_expenses.count).to eq(2)
        expect(result_expenses).to include(expense_3)
        expect(result_expenses).to include(expense_4)
      end
    end

    describe "other_expenses" do
      it "return expenses other = false and income = false" do
        user = FactoryGirl.create(:user)
        expense = FactoryGirl.create(:expense, user: user, other: true)
        expense_2 = FactoryGirl.create(:expense, user: user, income: true) # noise
        expense_3 = FactoryGirl.create(:expense, user: user) # noise
        expense_4 = FactoryGirl.create(:expense, user: user) # noise

        result_expenses = user.expenses.other_expenses

        expect(result_expenses.count).to eq(1)
        expect(result_expenses).to include(expense)
      end
    end

    describe "incomes" do
      it "return expenses other = false and income = false" do
        user = FactoryGirl.create(:user)
        expense = FactoryGirl.create(:expense, user: user, other: true) # noise
        expense_2 = FactoryGirl.create(:expense, user: user, income: true)
        expense_3 = FactoryGirl.create(:expense, user: user) # noise
        expense_4 = FactoryGirl.create(:expense, user: user) # noise

        result_expenses = user.expenses.incomes

        expect(result_expenses.count).to eq(1)
        expect(result_expenses).to include(expense_2)
      end
    end
  end

end