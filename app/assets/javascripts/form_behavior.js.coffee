jQuery ->
  $('form.submit-once').live 'submit', -> 
    $(@).find('input[type="submit"], button[type="submit"]').attr('disabled', 'disabled')
    return true
  
  # new character Form specifics
  $('#character_register_back').bind 'click', ->
    $(@).attr('disabled', 'disabled')
    $('#new_character input[type="text"]').removeAttr('readonly')
    $('#radio_placeholder').slideUp 350, -> 
      $(@).html('').removeClass('last-of.group').prev().addClass('last-of-group')
      $('#character_submit').html "Get Characters"
      
  # Used for the hints in the compact form. What it does:
  $('form.compact input[type="text"]').live 'blur', ->
    # when the user leaves a input field of type text
    if $(@).val() == ""
      # and the value of former field is empty, reset the hint visibility
      # aka make it visible
      $(@).siblings('span.hint').css 'opacity', ''
    else
      # if there is context in former input field, set the opacity of 
      # the hint to zero -> hide the hint
      $(@).siblings('span.hint').css 'opacity', '0'
  
  return false