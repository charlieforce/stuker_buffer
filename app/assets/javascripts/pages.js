$(function() {

  /* for showing/hiding unit number field on user creation based on role */
  $(document).on('change',"input:radio[name='post[send_now]']", function(){
    if($(this).val() == "true"){
      $(".post_scheduled_at").hide();
    }else{
      $(".post_scheduled_at").show();
    }
  });
});