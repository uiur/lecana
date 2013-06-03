# encoding: UTF-8

class SettingsController < ApplicationController
  before_filter :check_no_setting, :only => [:new, :create]
  skip_filter :check_setting, :only => [:new, :create]

  def new
    @user = current_user
    @setting = @user.build_setting
  end
  
  def create
    @setting = current_user.build_setting(params[:setting])

    if @setting.save
      redirect_to root_path, notice: '設定が完了しました！「講義を見る」から時間割を作りましょう！'
    else
      redirect_to new_settings_path
    end
  end

  def edit
    @setting = current_user.setting
  end

  def update
    if current_user.setting.update_attributes(params[:setting])
      redirect_to edit_settings_path, :notice => '設定を更新しました！'
    else
      redirect_to edit_settings_path
    end
  end

  def faculty_select
    faculties = Faculty.where(college_id: params[:id]) unless params[:id].blank?
    render :partial => 'faculties', :locals => {faculties: faculties}
  end

  private
  def check_no_setting
    redirect_to root_path if current_user.setting
  end
end
