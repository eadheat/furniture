Notes = {
  eventClicked: function(calEvent, jsEvent, view){
    alert(calEvent.title);
  },
  dayClicked: function(date, jsEvent, view){
    alert("dayClicked");
  },
  init: function(){
    $('#calendar').fullCalendar({
      eventSources: [{
        url: "/th/notes/event",
        color: 'sky',
        textColor: 'black'
      }],
      dayClick: Notes.dayClicked,
      eventClick: Notes.eventClicked,
    });
  }
};

$(Notes.init);