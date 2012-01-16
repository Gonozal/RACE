jQuery ->
  
  # Show notifications. Type should be either alert, success or notice and
  # equals the class added to the wrapping container.
  # 
  # @param [string] msg the message to be displayed in the notification.
  # @param [integer] duration the duration for which the notification should be displayed
  window.notify = (type, msg, duration) ->
    # create the notification nodes
    closer = '<a class="close" href="#" title="hide">x</a>'
    notification = $('<div class="'+type+'"><strong>'+closer+msg+'</strong></div>)').hide()
    # insert the notification on top the content, below the navigation
    $('#content').before(notification)
    notification.slideDown 300
    
    # remove the notification when someone presses the close button
    notification.find('a.close').bind 'click', ->
      $(@).parent().parent().slideUp 300, ->
        $(@).remove()
      false
    
    # automatically remove the notification after a set amount of time 
    # (if a time > 0 has been set)
    if duration > 0
      setTimeout(->
        notification.slideUp 300, ->
          $(@).remove()
      , duration)
    
  
  # All elements below (next SIBLING, not CHILDREN) an element with data-collapseable
  # are slide-toggle-able. data-collapsable = collapsed are automatically collapsed on site load
  # on Double-click, hide all other elements and display only clicked element
  $('[data-collapseable]').dblclick ->
    $(@).siblings('[data-collapseable]').next().slideUp 250
    $(@).siblings('[data-collapseable]').removeClass("expanded").addClass("collapsed")
    $(@).removeClass("collapsed").addClass("expanded")
    $(@).next().slideDown 250
      
  
  
  # Toggle "slide" state on single click. Do not allow queueing of slides
  $('[data-collapseable]').click ->
    if $(@).next().queue("fx").length == 0
      $(@).toggleClass("collapsed expanded")
      $(@).next().slideToggle 250
    
  # collapse data-collapsable="collapsed" on document.ready
  $('[data-collapseable="callapsed"]').next().hide()
      