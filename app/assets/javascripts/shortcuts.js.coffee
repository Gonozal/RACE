jQuery ->
  # Keyboard shortcuts
  $(document).bind 'keypress', (e) ->
    console.log e.keyCode
    if e.keyCode == 102
      # 'f' pressed
      showSearchWrapper()
      false
      
  $('form').bind 'keypress', (e) ->
    if $(@).is(":visible")
      e.stopPropagation()
