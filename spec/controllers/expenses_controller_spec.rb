require "rails_helper"

RSpec.describe ExpensesController, :type => :controller do

  describe "create" do
    it "create new expense" do      
      sign_in_as(refinery_admin) do
        get :index, locale: "en"

        expect(assigns[:nomenclature_classes]).to eq([
          ["-select-", ""],
          ["#{nomenclature_class_1.code} #{nomenclature_class_1.legend_en}", nomenclature_class_1.id],
          ["#{nomenclature_class_2.code} #{nomenclature_class_2.legend_en}", nomenclature_class_2.id]
        ])
      end
    end
  end
  
end