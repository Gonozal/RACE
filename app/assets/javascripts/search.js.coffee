jQuery ->
  # Navigation search bar behavior
  $searchInput = $('#searchinput')
  $searchWrapper = $('#searchwrapper')
  $searchActivator = $('#searchactivator')
  window.searchElements = null
  window.searchElementIndex = 0
  
  # search bar event listeners: Show the searchbar when clicked on the 
  # magnifying glass link and hide it when the user clicks anywhere but in the 
  # search view
  $searchActivator.bind 'click', -> 
    if $searchWrapper.is(':visible')
      hideSearchWrapper()
      $(document).unbind 'click', hideSearchWrapper
    else
      showSearchWrapper()
      $(document).bind 'click', hideSearchWrapper
    false 
  
  # some keyboard handling for the form
  $searchInput.bind 'keydown', (e) ->
    console.log e.keyCode
    if e.keyCode == 27
      # escape
      if $(this).val().length > 0
        $(this).val ""
      else
        hideSearchWrapper()
    else if e.keyCode == 13
      # enter
      window.location = $(window.searchElements[window.searchElementIndex]).children().first().attr "href"
    else if e.keyCode == 40
      # arrow down
      selectNextSearchEntry()
      false
    else if e.keyCode == 38
      # arrow up
      selectPrevSearchEntry()
      false
    
    
  # hides the search result view
  window.hideSearchWrapper = ->
    $searchActivator.removeClass("selected")
    $searchWrapper.hide()
    document.body.focus()
  
  window.showSearchWrapper = ->
    $searchActivator.addClass("selected")
    $searchWrapper.show()
    $searchInput.focus().select()
    
  # event handler to select focused search element by mouse hover
  $('#searchwrapper li').live 'mousemove', ->
    unfocusCurrentSearchElement()
    window.searchElementIndex = $(searchElements).filter($(@)).index()
    $(@).addClass('focus')
    
  # select the next search entry
  selectNextSearchEntry = ->
    # cancel if there are no search elements
    return false unless searchElements?
    
    # un-focus the currently focused search element
    unfocusCurrentSearchElement()
    window.searchElementIndex += 1
    # select new focused search element. Wraps at the top and bottom
    if window.searchElementIndex < searchElements.length
      $(searchElements[window.searchElementIndex]).addClass('focus')
    else
      $(searchElements[0]).addClass('focus')
      window.searchElementIndex = 0
    
  # select the previous search entry
  selectPrevSearchEntry = ->
    # cancel if there are no search elements
    return false unless searchElements?
    
    # un-focus the currently focused search element
    unfocusCurrentSearchElement()
    window.searchElementIndex -= 1
    # select new focused search element. Wraps at the top and bottom
    if window.searchElementIndex >= 0
      $(searchElements[window.searchElementIndex]).addClass('focus')
    else
      $(searchElements).last().addClass('focus')
      window.searchElementIndex = searchElements.length - 1
    
  unfocusCurrentSearchElement = ->
    return false unless searchElements?
    $(searchElements[window.searchElementIndex]).removeClass('focus')
  
  
  # stops all click events from within the search view from propagating
  $searchWrapper.bind 'click', -> false
  
  # variables needed to keep track of the keyboard input time etc.
  keyTimeout = null
  submitDelay = 333
  searchform = $searchWrapper.find('form')
  laststring = ""
  
  # Character input (and therefore submit) handling
  $($searchInput).bind 'keyup', (e) ->
    clearTimeout keyTimeout if keyTimeout?
    
    # only submit if the value of the input field has changed
    # and the length is greater or equal 3
    unless $(this).val().length < 3 or laststring == $(@).val()
      keyTimeout = setTimeout ->
        searchform.submit()
      , submitDelay
    # update the last string variable with the currernt value
    laststring = $(@).val()
  
  $('#searchwrapper form').bind 'submit', -> console.log "submitting"