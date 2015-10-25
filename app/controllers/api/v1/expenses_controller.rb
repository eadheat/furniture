module Api::V1
  class ExpensesController < ApiController
  	def index
      if params[:other].present?
  		  expenses_json = current_user.expenses.other_expenses.map(&:attributes)
      else
        expenses_json = current_user.expenses.my_expenses.map(&:attributes)
      end
  		render json: {
  			status: "OK",
  			expenses: expenses_json
  		}.to_json
  	end

    def show
      expense = current_user.expenses.find(params[:id])
      render json: {
        status: "OK",
        expense: expense.attributes
      }.to_json
    end
  end
end