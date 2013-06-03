$(($)->
  if $('.pagination').size() > 0
    $('#activity_box').infinitescroll { navSelector  : ".pagination", nextSelector : ".pagination .next a", itemSelector : "#activity_box .activity_container", loading: { msgText : "", finishedMsg : '' } }
)