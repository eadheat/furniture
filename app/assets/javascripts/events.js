Events = {
  eventClicked: function(calEvent, jsEvent, view){
    $('#click-dialog').modal();
    $("#delete-event-btn-id").attr("eid", calEvent.id);
    $("#delete-event-btn-id").show();

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
  removeEvent: function(){
    if (!confirm("Are you sure?")) {
      return false;
    }
    var eid = $(this).attr("eid");
    var url = "/en/events/"+ eid
    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      dataType: 'json',
      success: function(result) {
        $("#calendar").fullCalendar("refetchEvents");
        $('#click-dialog').modal('hide');
      },
      error: function(){
        $("#calendar").fullCalendar("refetchEvents");
        $('#click-dialog').modal('hide');
      },
      timeout: 10000,
      type: "DELETE",
      url: url
    });
  },
  init: function(){
    $('.datepicker').datepicker({
      format: 'dd/mm/yyyy',
      autoclose: true,
      todayHighlight: true
    });

    $('#click-dialog').on('hidden.bs.modal', function (e) {
      $("#delete-event-btn-id").hide();
    });

    $(document).on("click", "#submit-event-btn-id", Events.addEventSubmit);
    $(document).on("click", "#delete-event-btn-id", Events.removeEvent);

    $('#calendar').fullCalendar({
      eventSources: [{
        url: "/th/events/event",
        color: '#009999',
        textColor: 'white',
      }],
      dayClick: Events.dayClicked,
      eventClick: Events.eventClicked
    });
  }
};

$(Events.init);