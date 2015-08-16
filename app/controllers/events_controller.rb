class EventsController < ApplicationController
  def index; end

  def event
    events = current_user.events
    # json = [
    #   {
    #     title: "My Event",
    #     allDay: true,
    #     start: "2015-08-14"
    #   },
    #   {
    #     title: "My Event 2",
    #     allDay: true,
    #     start: "2015-08-16",
    #     end: "2015-08-18"
    #   },
    # ]
    events = events.map do |event|
       {
        title: event.description,
        allDay: true,
        start: event.from,
        end: event.to
      }
    end
    render json: events
  end

  def add_event
    event = Event.new(event_params)
    event.user = current_user

    if event.save
      render json: {success: true, errors: nil}
    else
      render json: {success: false, errors: event.errors.full_messages.join(", ")}
    end
  end

  private
  def event_params
    params.require(:event).permit(:from, :to, :description);
  end
end