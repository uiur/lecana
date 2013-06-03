$('#post_content').val('')
$('#posts').html("<%=j(render 'posts/posts', :posts => @posts) %>")