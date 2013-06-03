# encoding: UTF-8
class PostsController < ApplicationController
  before_filter :check_current_user, :only => :destroy

  # GET /posts/:id
  def show
    @post = Post.find(params[:id])
  end


  # GET /users/:name/posts
  def index
    @user = User.find_by_name(params[:name])
    @posts = @user.posts
  end

  def create
    @postable = find_postable
    if @postable
      @post = @postable.posts.build(params[:post])
      @posts = @postable.posts
    else
      @post = Post.new(params[:post])
      @posts = current_user.posts
    end

    @post.user = current_user

    if @post.save
      flash[:notice] = 'コメントを投稿しました！'

      if params[:do_post_to_external] == "1"
        current_user.post_to_external(@post)
      end
    else
      flash[:error] = 'なにかエラーが起こったようです。もう一度試してみてください'
    end
  end

  def destroy
    if @post.destroy
      redirect_to :back, notice: 'コメントを削除しました'
    else
      redirect_to :back
    end
  end

  private
  def find_postable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value) unless $1 == 'user'
      end
    end
    return nil
  end

  def check_current_user
    @post = Post.find(params[:id])

    unless current_user.have?(@post)
      redirect_to root_path
    end
  end
end
