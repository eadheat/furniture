module Api::V1
  class ExpensesController < ApiController
    before_action :load_summary_data, only: [:index]

    def load_summary_data
      @total_of_today = current_user.expenses.my_expenses.where(:date => Time.current.to_date).map(&:amount).sum
    end

  	def index
      total_daily_of_this_month = current_user.total_of_this_month
      total_other_of_this_month = current_user.total_of_this_month(other_expense: true)
      total_of_this_month = total_daily_of_this_month + total_other_of_this_month

      render json: {
        status: "OK",
        total_of_today: @total_of_today,
        daily_total_of_this_month: total_daily_of_this_month,
        daily_average_of_this_month: current_user.average_of_this_month,
        other_total_of_this_month: total_other_of_this_month,
        other_average_of_this_month: current_user.average_of_this_month(other_expense: true),
        total_of_this_month: total_of_this_month,
        average_of_this_month: current_user.total_average_of_this_month,
        expenses: current_user.expenses.where(income: false).order("created_at desc").limit(30).map(&:attributes)
      }.to_json
  	end

    def show
      expense = current_user.expenses.find(params[:id])
      render json: {
        status: "OK",
        expense: expense.attributes
      }.to_json
    end

    def create
      expense = Expense.new(expense_params)
      expense.user = current_user

      (params[:expense_type] == "other_expense") ? expense.other = true : expense.other = false
      
      if expense.valid? && expense.save
        render json: {
          status: "OK",
          expense: expense.attributes
        }.to_json
      else
        render json: {
          error: t('expense.errors.full_messages.json(', ')')}, status: :unprocessable_entity
      end
    end

    def update
      expense = current_user.expenses.find(params[:id])
      expense.update_attributes(expense_params)
      expense.reload
      render json: {
        status: "OK",
        expense: expense.attributes
      }.to_json
    end

    def destroy
      expense = current_user.expenses.find(params[:id])
      if expense.destroy
        render json: { status: "OK" }.to_json
      else
        render json: { error: true}, status: :unprocessable_entity
      end
    end

    private
    def expense_params
      params.require(:expense).permit(:date, :detail, :amount)
    end
  end
end