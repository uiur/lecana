# encoding: UTF-8

class UploadsController < ApplicationController
  def create
    @upload = Upload.new(params[:upload])
    subject = Subject.find(params[:subject_id])
    @upload.subject = subject
    @upload.user = current_user

    if @upload.save
      redirect_to subject_path(subject), :notice => 'ファイルをアップロードしました！'
    else
      redirect_to subject_path(subject), :alert => 'なにかエラーが起きたようです。もう一度試してみてください'
    end
  end

  def destroy
    @upload = Upload.where(id: params[:id], user_id: current_user.id).first
    subject = Subject.find(params[:subject_id])

    if @upload
      @upload.destroy
      flash[:notice] = 'ファイルを削除しました'
    end

    redirect_to subject_path(subject)
  end
end
