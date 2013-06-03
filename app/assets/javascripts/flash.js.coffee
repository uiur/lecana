renderNotice = (msg) ->
  $('#notice .container').append('<div class="alert-message small notice">' + msg + '</div>')
renderError = (msg) ->
  $('#notice .container').append('<div class="alert-message small error">' + msg + '</div>')
$ ->
  $(document).ajaxComplete (event, request) ->
    notice = request.getResponseHeader('flash-notice')
    error = request.getResponseHeader('flash-error')
    renderNotice notice if notice
    renderError error if error

  # noticeの閉じる処理
  $('#notice_button_close').click ()->
    $(this).parent('#notice_balloon').fadeOut()