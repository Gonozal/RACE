jQuery ->
  # 
  nav = document.getElementById('navigation')
  content = document.getElementById('content')
  init = nav.offsetTop
  contentInit = nav.offsetHeight+'px'
  docked = null
  
  window.onscroll = -> 
    if !docked && (nav.offsetTop - scrollTop() < 0)
      nav.style.top = 0
      nav.style.position = 'fixed'
      nav.className = 'docked'
      docked = true
      return null
    else if docked && (scrollTop() <= init)
      nav.style.position = ''
      nav.style.top = ''
      nav.className = nav.className.replace('docked', '')
      docked = false
      return null

  scrollTop = -> document.body.scrollTop || document.documentElement.scrollTop
  
  # Navigation Home behavior
  navHoverTime = 0
  $('#navigation > li').hoverIntent(
    interval: 50,
    over: -> $(this).children('ul').fadeIn(100),
    timeout: 150,
    out: ->  $(this).children('ul').fadeOut(200)
  )
  
jQuery ->
  # The Clock...
  jQuery ->
    $time = $('#evetime_hours')
    hours = parseInt $time.html().match(/^(\d+):/)[1]
    minutes = parseInt $time.html().match(/:(\d+)/)[1]
    $date = $('#evetime_date')
    date = $date.html().match(/^(\d+).(\d+).(\d+)/)
    year = parseInt date[1]
    month = parseInt date[2]
    days = parseInt date[3]
    
    window.setInterval ->
      minutes += 1
      if (minutes >= 60)
        minutes = 0
        hours += 1
        if(hours >= 24)
          hours = 0
          days += 1
      
      $time.html "#{pad hours, 2}:#{pad minutes, 2}"
      $date.html "#{year}:#{pad month, 2}:#{pad days, 2}"
    , 60000
    
    pad = (number, length) ->
      str = (String) number
      while str.length < length
        str = '0' + str
      str
