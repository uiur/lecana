$(($)->
  $('#global_nav_account').hover(()->
    $(this).children('#h_signin_box_wrapper').fadeIn()
  , ()->
    $(this).children('#h_signin_box_wrapper').fadeOut()
  )

  # ユーザー検索
  $('#h_user_search_button').click (event)->
    $('#h_user_search_box_wrapper').toggle()
    event.stopPropagation()
  $('#page').click ()->
    $('#h_user_search_box_wrapper').hide()
  $('#h_user_search_box_wrapper').click (event)->
    event.stopPropagation()

  # ユーザーメニュー
  $('#h_user_nav_button').click (event)->
    $('#h_user_nav_wrapper').toggle()
    event.stopPropagation()
  $('#page').click ()->
    $('#h_user_nav_wrapper').hide()
   $('#h_user_nav_wrapper').click (event)->
    event.stopPropagation()

)
