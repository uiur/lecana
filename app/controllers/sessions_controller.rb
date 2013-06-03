# encoding: UTF-8

class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = Userauth.find_by_uid_and_provider(auth["uid"],auth["provider"]).try(:user) || User.create_with_omniauth(auth)
    session[:user_id] = user.id

    user.update_names!(auth)
    user.update_image_url!

    redirect_to root_url, :notice => "サインインしました!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "サインアウトしました"
  end
end
