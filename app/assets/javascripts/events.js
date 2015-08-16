Events = {
  eventClicked: function(calEvent, jsEvent, view){
    alert(calEvent.title);
  },
  showClickDialog: function(date, jsEvent, view){
    $("#click-dialog").removeClass("hidden");
    var m = $.datepicker.formatDate('dd/mm/yy', new Date(date));
    $("#start-event-date").text(m);
    $("#end-event-date").text(m);
    $("#click-dialog").dialog({
      modal: true,
      title: "Add Event",
      minWidth: 480,
      minHeight: 270,
      buttons: {
        "Add Event": Events.addEventSubmit,
        Cancel: function() {
          $("#click-dialog").dialog("destroy");
          $("#click-dialog").addClass("hidden");
        }
      }
    });
  },
  addEventSubmit: function(){
    var eventForm = $("#event-form");
    var formData = {
      utf8: "1",
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
          $("#click-dialog").dialog("destroy");
          $("#click-dialog").addClass("hidden");
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
    });

    $('#calendar').fullCalendar({
      eventSources: [{
        url: "/th/events/event",
        color: 'sky',
        textColor: 'black'
      }],
      dayClick: Events.dayClicked,
      eventClick: Events.eventClicked,
    });
  }
};

$(Events.init);