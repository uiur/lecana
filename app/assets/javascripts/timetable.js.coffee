$(()=>
  # デフォルトの曜日の設定
  day = (new Date()).getDay()
  if (day == 0) | (day >= 6)
    day = 1
  $('#stt_table_' + day).addClass('stt_current')
  $('#stt_button_day_' + day).addClass('stt_button_current')

  set_tt_nav()
  for day_no in [1..6]
    set_stt_menu_day(day_no)
  set_stt_menu_other()
  set_tt_menu_item()
  set_stt_menu_item()
)

###
  menu navigation
###
set_tt_nav =()->
  # main timetable
  $('#tt_button_pulldown').click ()->
    # 開いているとき
    if $(this).hasClass('state_open')
      $(this).next('ul').fadeOut();
      $(this).removeClass('state_open')
    # 閉じているとき
    else
      $(this).next('ul').fadeIn()
      $(this).addClass('state_open')

  # side timetable
  $('#stt_button_pulldown').click ()->
    # 開いているとき
    if $(this).hasClass('state_open')
      $(this).next('ul').fadeOut();
      $(this).removeClass('state_open')
    # 閉じているとき
    else
      $(this).next('ul').fadeIn()
      $(this).addClass('state_open')

###
  main timetable navigation
###
set_tt_menu_item =()->
  # マウスオーバー時にメニューを表示
  $('.tt_cell_info').hover(()->
    $(this).children('.tt_nav_item').animate({opacity: "1.0"}, 300);
  , ()->
    $(this).children('.tt_nav_item').animate({opacity: "0.0"}, 300);
  )

  # 次の講義
  $('.tt_button_next_lecture').click ()->
    current = $(this).parents('.tt_nav_item').prev('.tt_box_item').children('.tt_current_lecture')
    if current.next().html()
      current.fadeOut('normal', ()->
        $(this).removeClass('tt_current_lecture')
        $(this).next().fadeIn().addClass('tt_current_lecture')
      )

  # 前の講義
  $('.tt_button_prev_lecture').click ()->
    current = $(this).parents('.tt_nav_item').prev('.tt_box_item').children('.tt_current_lecture')
    if current.prev().html()
      current.fadeOut('normal', ()->
        $(this).removeClass('tt_current_lecture')
        $(this).prev().fadeIn().addClass('tt_current_lecture')
      )

###
  side timetable navigation
###
set_stt_menu_day =(day_no)->
  $('#stt_button_day_'+day_no).click ()->
    # すでに表示されている場合
    if $(this).hasClass('stt_button_current')
      return

    # メニューの表示切替
    $('.stt_button_current').removeClass('stt_button_current')
    $(this).addClass('stt_button_current')

    # 時間割の表示切替
    $('.stt_current').fadeOut(200, ()->
      $(this).removeClass('stt_current')
      $('#stt_table_' + day_no).fadeIn(300).addClass('stt_current');
    )

set_stt_menu_other =()->
  # その他
  $('#stt_button_other').click ()->
    # すでに表示されている場合
    if $(this).hasClass('stt_button_current')
      return

    # メニューの表示切替
    $('.stt_button_current').removeClass('stt_button_current')
    $(this).addClass('stt_button_current')

    # 時間割の表示切替
    $('.stt_current').fadeOut(200, ()->
      $(this).removeClass('stt_current')
      $('#stt_table_other').fadeIn(300).addClass('stt_current');
    )

  # 時間割一覧
  $('#stt_button_viewall').click (event)->
    $('#stt_popup_timetable_wrapper').fadeIn()
    event.stopPropagation()
  # # 閉じる
  $('#stt_button_close_popup_timetable').click (event)->
    $('#stt_popup_timetable_wrapper').fadeOut()
    event.stopPropagation()
  $('#stt_popup_timetable_wrapper').click ()->
    $('#stt_popup_timetable_wrapper').fadeOut()
  $('#stt_popup_timetable_content').click (event)->
    event.stopPropagation()


set_stt_menu_item =()->
  # マウスオーバー時にメニューを表示
  $('.stt_cell_info').hover(()->
    $(this).children('.stt_nav_item').animate({opacity: "1.0"}, 300);
  , ()->
    $(this).children('.stt_nav_item').animate({opacity: "0.0"}, 300);
  )

  # 次の講義
  $('.stt_button_next_lecture').click ()->
    current = $(this).parents('.stt_nav_item').prev('.stt_box_item').children('.stt_current_lecture')
    if current.next().html()
      current.fadeOut('normal', ()->
        $(this).removeClass('stt_current_lecture')
        $(this).next().fadeIn().addClass('stt_current_lecture')
      )

  # 前の講義
  $('.stt_button_prev_lecture').click ()->
    current = $(this).parents('.stt_nav_item').prev('.stt_box_item').children('.stt_current_lecture')
    if current.prev().html()
      current.fadeOut('normal', ()->
        $(this).removeClass('stt_current_lecture')
        $(this).prev().fadeIn().addClass('stt_current_lecture')
      )
