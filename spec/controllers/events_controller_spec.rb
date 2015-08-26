require "rails_helper"

RSpec.describe EventsController, :type => :controller do

  describe "add_event" do
    it "add new event to calendar" do  
      user = FactoryGirl.create(:user)  

      sign_in_as(user) do
        expect {
          post :add_event,
          event: {
            from: Time.now,
            to: Time.now + 2.days,
            description: "Add test event"
          }, locale: "en"
        }.to change(Event, :count).by(1)

        expect(user.events.last).to have_attributes(description: "Add test event")
      end
    end

    it "update event to calendar" do  
      user = FactoryGirl.create(:user)  
      event = FactoryGirl.create(:event, user: user)

      sign_in_as(user) do
        expect {
          post :add_event,
          event: {
            id: event.id,
            from: Time.now,
            to: Time.now + 2.days,
            description: "Add test event"
          }, locale: "en"
        }.to change(Event, :count).by(0)

        expect(event.reload.description).to eq("Add test event")
      end
    end
  end

  describe "destroy" do
    it "delete event" do
      user = FactoryGirl.create(:user)  
      event = FactoryGirl.create(:event, user: user, description: "111")
      event_2 = FactoryGirl.create(:event, user: user, description: "222")

      sign_in_as(user) do 
        expect {
          delete :destroy, id: event.id, locale: :en
        }.to change(Event, :count).by(-1)

        expect(user.events.count).to eq(1)
      end
    end
  end
end