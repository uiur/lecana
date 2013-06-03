# encoding: UTF-8
class UsersController < ApplicationController
  def show
    @user = User.find_by_name!(params[:name])
    @timetable = @user.timetable(params[:term], params[:year])
    @activities = @user.activities.active.limit(10)
  end

  def timetable
    @user = User.find_by_name(params[:name])
    @timetable = @user.timetable(params[:term], params[:year])
  end

  def index
    if user = User.find_by_name(params[:search])
      redirect_to user_path(user.name)
    else
      @users = User.where(["name like ?", "%#{params[:search]}%"]).page(params[:page])
      redirect_to user_path(@users.first.name) if @users.size == 1
    end
  end

  # 他のユーザの時間割をコピーする
  def copy_timetable
    user = User.find(params[:user_id])
    subject_ids = user.subject_infos.joins(:terms).where(year: params[:year], terms: {ord: params[:term]}).select(:subject_id).map(&:subject_id)
    
    subject_infos = SubjectInfo.joins(:terms).where(:subject_id => subject_ids, :year => YEAR, :terms => {:ord => params[:term]})
    missed_subject_infos = []
    
    subject_infos.each do |subject_info|
      unless current_user.register(subject_info)
        missed_subject_infos << subject_info
      end
    end

    if missed_subject_infos.empty?
      redirect_to user_path(current_user.name),
        :notice => "#{user.name} の時間割を今年にコピーしました"
    else
      redirect_to user_path(current_user.name),
        :error => "#{missed_subject_infos.map{|info| info.name}.join(", ")} の登録ができませんでした。登録できる科目は一つの時限に3つまでです!"
    end
  end
end
