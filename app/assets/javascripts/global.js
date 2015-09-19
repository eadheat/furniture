Global = {
  sendContact: function(){
    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      data: $("#contact-us-form").serialize(),
      success: function(result) {
        $('#myContactModal').modal("hide");
      },
      error: function(){
        $("#contact-us-form").find("input").filter(function(){
          if ($(this).val()){
            $(this).css("borderColor", "#ccc");
          }else{
            $(this).css("borderColor", "red");
          }
        });
        var textarea = $("#contact-us-form").find("textarea");
        if ($(textarea).val()){
          $(textarea).css("borderColor", "#ccc");
        }else{
          $(textarea).css("borderColor", "red");
        }
      },
      timeout: 10000,
      type: "POST",
      url: "/th/contacts/send_contact"
    });
  },
  init: function(){
    $('#myContactModal').on('hidden.bs.modal', function (e) {
      $('#contact-us-form')[0].reset();
      $('#contact-us-form').find("input").css("borderColor", "#ccc");
      $('#contact-us-form').find("textarea").css("borderColor", "#ccc");
    });

    $('.pay-date').datepicker({
      format: "dd.mm.yyyy",
      autoclose: true,
      disableTouchKeyboard: true,
      todayHighlight: true
    });

    $(document).on("click", "#submit-contact-btn", Global.sendContact);

    $(document).on('touchstart', 'li.ui-menu-item',
      function () {
        if (!window.ontouchstart && !navigator.MaxTouchPoints && !navigator.msMaxTouchPoints) {
          $(this).trigger("click");
        }
      }
    );

  }
};

$(Global.init);