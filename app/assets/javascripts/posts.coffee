# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Count max length
$(document).on 'page:change', ->
  text_max = 140
  $('#maxCharacters').html text_max + ' characters remaining'

  $('#post_content').keyup ->  	
    text_length = $('#post_content').val().length
    text_remaining = text_max - text_length

    $('#maxCharacters').html text_remaining + ' characters remaining'
    if text_remaining <= 10
      $('#maxCharacters').css 'color', 'red'    
    return
  return