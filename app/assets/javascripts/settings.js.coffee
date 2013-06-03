$(()->
  # 現在のステップ
  setting_current_step = 0

  # ステップの数
  setting_steps_num = $('#setting_steps fieldset').children('div').length

  # ボックスの位置の初期化
  $('#setting_steps').css('margin-left', '0px')

  # クラスの追加
  $('#setting_steps fieldset').children('div').not('.actions').addClass('setting_step')

  # ステップの横幅
  setting_step_width = 598 #$('.setting_step').eq(0).width()

  # navigationを表示する
  $('#setting_navigation').css('display','block') # なぜかshow()じゃ動かなかった
  $('#setting_navigation li:first-child').addClass('selected')

  # navigationのボタン処理
  $('#setting_navigation a').click ()->
    $parent_ul = $(this).closest('ul')
    $parent_li = $(this).parents('li')
    setting_current_step = $parent_ul.children('li').index($parent_li)
    slide_steps()

  # 確認画面の作成
  create_confirm = ()->
    $confirm_panel = $('<div/>').addClass('confirm_panel').append($('<p/>').text('以下の内容で設定します。よろしいですか？'))
    $input_data = $('<dl/>')
      .append($('<dt/>').addClass('college').text('大学'))
      .append($('<dd/>'))
      .append($('<dt/>').addClass('faculty').text('所属学部'))
      .append($('<dd/>'))
      .append($('<dt/>').addClass('entered_at').text('入学年度'))
      .append($('<dd/>'))
    $('#setting_steps fieldset').append($confirm_panel.append($input_data))
    reflesh_confirm()

  # 確認画面の更新
  reflesh_confirm = ()->
    $('.confirm_panel .college').next('dd').text($('#setting_college_input select option:selected').text())
    $('.confirm_panel .faculty').next('dd').text($('#setting_faculties_select select option:selected').text())
    $('.confirm_panel .entered_at').next('dd').text($('#setting_entered_at_input select option:selected').text())


  slide_steps = ()->
    $('#setting_steps').animate({
      marginLeft: -1 * setting_step_width * setting_current_step + 'px'
    }, 500, ()->
      # 下部ナビゲーションの処理
      $nav_ul = $('#setting_navigation ul')
      $nav_ul.children('.selected').removeClass('selected')
      $nav_ul.children('li').eq(setting_current_step).addClass('selected') 
    )


  # 確認画面の作成と更新の設定
  create_confirm()
  $('#setting_steps fieldset select').change(reflesh_confirm)

  # OKボタンを確認画面に移動
  $('.confirm_panel').append($('#setting_steps fieldset .actions'))

  # ページ送り
  $nav_pager = $('<div/>').addClass('nav_pager')

  # # 「戻る」ボタン
  $button_prev = $('<a/>').addClass('button_prev').text('戻る')
  $nav_pager.append($button_prev)

  $button_prev.click ()->
    setting_current_step--
    slide_steps()

  # # 「進む」ボタン
  $button_next = $('<a/>').addClass('button_next').text('進む')
  $nav_pager.append($button_next)

  $button_next.click ()->
    setting_current_step++
    slide_steps()

  # ページ送りを挿入
  $('#setting_steps .setting_step, #setting_steps .confirm_panel').append($nav_pager)

  # 1番目のstepでは「戻る」を表示しない
  $('#setting_steps .setting_step .nav_pager').eq(0).children('.button_prev').hide()
  # confirmでは「進む」を表示しない
  $('#setting_steps .confirm_panel .nav_pager').children('.button_next').hide()
)


# 以下、よくわからないのでコメントアウトしておきます(03/17 Otani)
# jQuery ->
#   $('#user_college_id').change ->
#    college = $('select#user_college_id :selected').val();
#    college = '0' if college == ''
#    $.get('/settings/faculty_select/' + college, (data) ->
#      $('#faculties_select').html(data)
#    )
#    false
