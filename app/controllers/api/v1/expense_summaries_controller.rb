module Api::V1
  class ExpenseSummariesController < ApiController
    def index
      expenses_json = current_user.expenses.map(&:attributes)
      render json: {
        status: "OK",
        expenses: expenses_json
      }.to_json
    end
  end
end