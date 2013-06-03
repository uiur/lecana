$(()->
  $('.favs').live( 'mouseenter', ()->
    $(this).children('.favs_users').fadeIn()
  )
  $('.favs').live( 'mouseleave', ()->
    $(this).children('.favs_users').fadeOut()
  )
)
