$(function() {

  $(document).on('change',"#post_sending_mode", function(){
    if($(this).val() == "Now"){
      $(".once").hide();
      $(".recurring").hide();
    }else if($(this).val() == "Once"){
      $(".recurring").hide();
      $(".once").show();
    }else{
    	$(".recurring").show();
    	$(".once").show();
    }

  });
});