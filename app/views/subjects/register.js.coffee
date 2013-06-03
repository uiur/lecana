$('#register_<%= @subject.id %>').html("<%= j(render 'register', :subject => @subject, :year => @year) %>")
$('.users').html("<%= j(render 'shared/user_images', :users => @users) %>")