class NotesController < ApplicationController
  def index; end

  def event
    json = [
      {
        title: "My Event",
        allDay: true,
        start: "2015-08-14"
      },
      {
        title: "My Event 2",
        allDay: true,
        start: "2015-08-16",
        end: "2015-08-18"
      },
    ]
    render json: json
  end
end