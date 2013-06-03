# encoding: UTF-8
class ReviewsController < ApplicationController
  before_filter :authenticate_review_user!, :only => [:destroy]
  
  # GET /reviews/:id
  def show
    @review = Review.find(params[:id])
  end

  # GET /users/:name/reviews
  def index
    @user = User.find_by_name(params[:name])
    @reviews = @user.reviews
  end

  def create
    @review = Review.new(params[:review])
    @review.user = current_user

    subject_id = params[:subject_id]
    @review.subject_id = subject_id

    if @review.save
      if params[:do_post_to_external] == "1"
        current_user.post_to_external(@review)
      end
      redirect_to subject_path(subject_id), :notice => 'レビューを投稿しました！'
    else  
      redirect_to subject_path(subject_id), :alert => 'なにかエラーが起きたようです。もう一度試してみてください'
    end
  end

  def destroy
    if @review.destroy
      redirect_to subject_path(params[:subject_id]), :notice => "レビューを削除しました"
    else
      redirect_to subject_path(params[:subject_id]), :error => 'なにかエラーが起きたようです。もう一度試してみてください'
    end
  end

  private
  def authenticate_review_user!
    @review = Review.find(params[:id])
    unless @review.user == current_user
      redirect_to subject_path(params[:subject_id])
    end
  end
end
