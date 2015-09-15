require "rails_helper"

RSpec.describe SummariesController, :type => :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)  
    @expense_last_year = FactoryGirl.create(:expense, 
      date: Time.now - 1.year,
      amount: 200, 
      user: @user
    )
    @expense_last_year_2 = FactoryGirl.create(:expense, 
      date: Time.now - 1.year,
      amount: 400, 
      user: @user
    )
    @expense_current_year = FactoryGirl.create(:expense, 
      date: Time.now, 
      amount: 300,
      user: @user
    )
    @expense_current_year_2 = FactoryGirl.create(:expense, 
      date: Time.now, 
      amount: 600,
      user: @user
    )
  end

  describe "index" do
    it "show summaries" do
      sign_in_as(@user) do
        get :index, locale: :th

        expect(assigns[:summaries].count).to eq(2)
        expect(assigns[:summaries].keys).to eq([(Time.now - 1.year).year, Time.now.year])
        expect(assigns[:summaries].values.map(&:to_f)).to eq([600.0, 900.0])

        expect(response).to render_template("index")
      end
    end
  end
end