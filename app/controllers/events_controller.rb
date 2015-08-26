class EventsController < ApplicationController
  def index; end

  def event
    events = current_user.events
    events = events.map do |event|
       {
        id: event.id,
        title: event.description,
        allDay: true,
        start: event.from,
        end: event.to + 1.day,
        end_date: event.to,
        description: event.description
      }
    end
    render json: events
  end

  def add_event
    if params[:event][:id].present?
      event = Event.find(params[:event][:id])
      event.assign_attributes(event_params)
    else
      event = Event.new(event_params)
      event.user = current_user
    end

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