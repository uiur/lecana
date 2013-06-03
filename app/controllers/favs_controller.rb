class FavsController < ApplicationController
  before_filter :check_current_user, :only => :destroy
  def create
    @favable = find_favable
    if @favable
      @fav = @favable.favs.create(user: current_user)
    end
  end

  def destroy
    @fav.destroy
  end

  private
  def find_favable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value) unless $1 == 'user'
      end
    end
    return nil
  end

  def check_current_user
    @fav = Fav.find(params[:id])
    @favable = @fav.favable

    unless @fav.user == current_user
      redirect_to root_path
    end
  end
end
