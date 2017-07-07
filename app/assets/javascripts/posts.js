$(document).ready(function(){  
    $("#post_twitter").on("click", function(){
      if(this.checked) {
          var  text_max = 140;          
          $('#maxCharacters').html(text_max + ' characters remaining');
          $('#post_content').keyup(function(){            
            var text_length = $('#post_content').val().length;
            var text_remaining = text_max - text_length;
            if(text_remaining > 0){
              $('#maxCharacters').html(text_remaining + ' characters remaining');
            }

            if(text_remaining <= 10) {
              $('#maxCharacters').css('color', 'red');
            }

            if(text_remaining <= 0) {
              $('#post_content').attr('disable','disable');
            }
          });                  
      } else {
          alert("Checkbox is unchecked.");
      }
    }); 
});