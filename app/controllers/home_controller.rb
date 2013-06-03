# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  before_filter :check_unpresence_of_name, :only => [:set_name, :update_name]
  skip_filter :check_setting, :only => [:set_name, :update_name]

  def index
    if signed_in?
      @user = current_user
      @timetable = @user.timetable(params[:term], params[:year])
      @post = Post.new
      @activities = Activity.active.related_to(@user).page(params[:page])
    else
      @users = User.where(id: User.select(:id).map(&:id).shuffle[0..17])
      render :template => 'statics/index'
    end
  end

  # nameが設定されてないときにredirectする
  def set_name
    @user = current_user
  end

  def update_name
    if current_user.update_attributes(params[:user])
      redirect_to root_path
    else
      redirect_to set_name_path
    end
  end

  private
  def check_unpresence_of_name
    if signed_in? && current_user.name
      redirect_to root_path
    end
  end
end
