Notes = {
  init: function(){
    $('#calendar').fullCalendar({
      dayClick: function() {
        alert('a day has been clicked!');
      }
    });
  }
};

$(Notes.init);