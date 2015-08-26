Events = {
  eventClicked: function(calEvent, jsEvent, view){
    $('#click-dialog').modal();

    $("#event-status").text("");
    $("#modal-event-title").text("Event Details");
    $("input#event-id").val(calEvent.id);
    var start = $.datepicker.formatDate('dd/mm/yy', new Date(calEvent.start));
    var end = $.datepicker.formatDate('dd/mm/yy', new Date(calEvent.end_date));
    $("#start-event-date").text(start);
    $("#description_id").val(calEvent.description);
    
    $( ".datepicker" ).datepicker( "setDate", end );
  },
  showClickDialog: function(date, jsEvent, view){   
    $('#click-dialog').modal();

    $("#event-status").text("");
    $("#modal-event-title").text("Add Event");
    var m = $.datepicker.formatDate('dd/mm/yy', new Date(date));
    $("#start-event-date").text(m);    

    $( ".datepicker" ).datepicker( "setDate", m );
  },
  addEventSubmit: function(){
    var eventForm = $("#event-form");
    var formData = {
      utf8: "1",
      "event[id]": $("input#event-id").val(),
      "event[from]": $("#start-event-date").text(),
      "event[to]": $("#end-event-date").val(),
      "event[description]": $("#description_id").val()
    };
    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      data: formData,
      dataType: 'json',
      success: function(result) {
        $("#event-status").text(result.errors);
        if (result.success){
          $("#calendar").fullCalendar("refetchEvents");
          $('#click-dialog').modal('hide');
        }else{
          $("#event-status").text(result.errors);
        }
      },
      timeout: 10000,
      type: "POST",
      url: "/th/events/add_event"
    });
  },
  dayClicked: function(date, jsEvent, view){
    $("#end-event-date").val("");
    $("#event-status").text("");
    $("#description_id").val("");
    Events.showClickDialog(date, jsEvent, view);
  },
  init: function(){
    $('.datepicker').datepicker({
      format: 'dd/mm/yyyy',
      autoclose: true,
      todayHighlight: true
    });

    $(document).on("click", "#submit-event-btn-id", Events.addEventSubmit);

    $('#calendar').fullCalendar({
      eventSources: [{
        url: "/th/events/event",
        color: 'sky',
        textColor: 'white',
      }],
      dayClick: Events.dayClicked,
      eventClick: Events.eventClicked
    });
  }
};

$(Events.init);