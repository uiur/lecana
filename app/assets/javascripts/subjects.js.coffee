$(($)->
  # タブの設定
  $('#tab_box').tabs({ fx: { opacity: 'toggle', duration: 'normal' } })

  # 年度ナビゲーション
  $('#s_button_year').click ()->
    if $(this).hasClass('state_open')
      $(this).next('ul').fadeOut()
      $(this).removeClass('state_open')
    else
      $(this).next('ul').fadeIn()
      $(this).addClass('state_open')

  # review form
  $('.revfrm_input_content').elastic()

  # rating
  showRatingStar = ()->
    $('.reviews_star').empty()
    $('.reviews_star').raty { path: '/assets/', space: false, readOnly: true, start: -> return $(this).attr 'rating' }
  
    $('#star').raty { path: '/assets/', space: false, click: (score, evt) -> $('#review_rating').val(score) }
    $('#star2').raty { path: '/assets/', space: false, click: (score, evt) -> $('#review_rating2').val(score) }

  showRatingStar()

  # レビューのフォーム
  $(".revfrm_input_content").charCount({
    allowed: 400,
    warning: 380
  })



  $('table#uploads').tablesorter()
  
  if $('.pagination').size() > 0
    $('#subjects_table').infinitescroll { navSelector  : ".pagination", nextSelector : ".pagination .next a", itemSelector : "#subjects_table .subjects_row", loading: { msgText : "", finishedMsg : '' } }, showRatingStar


)
