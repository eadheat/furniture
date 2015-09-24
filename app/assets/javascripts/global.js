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
  is_touch_device: function() {
    return 'ontouchstart' in window // works on most browsers 
      || 'onmsgesturechange' in window; // works on ie10
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

    if (Global.is_touch_device()){
      $('html, body').bind('touchmove',function(e){
        var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
        var elm = $(this).offset();
        var x = touch.pageX - elm.left;
        var y = touch.pageY - elm.top;
        if(x < $(this).width() && x > 0){
          if(y < $(this).height() && y > 0){
            $('.scrollToTop').fadeIn();
          }
        }
      });
    }else{
      //Check to see if the window is top if not then display button
      $(window).scroll(function(){
        if ($(this).scrollTop() > 100) {
          $('.scrollToTop').fadeIn();
        } else {
          $('.scrollToTop').fadeOut();
        }
      });
    }
    
    //Click event to scroll to top
    $(document).on("click", ".scrollToTop", function(){
      if (Global.is_touch_device()){
        $("#top-navigation").attr("tabindex",-1).focus();
      }else{
        $('html, body').animate({scrollTop : 0},400);
      }
      return false;
    });

    $('body').on('hidden.bs.modal', '.modal', function () {
      $(this).removeData('bs.modal');
    });

  }
};

$(Global.init);