class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_presence_of_name, :except => [:set_name, :update_name]
  before_filter :check_setting
  before_filter :set_default_params
  after_filter :flash_to_headers

  helper_method :current_user, :signed_in?, :admin?
  
  rescue_from ActiveRecord::RecordNotFound, :with => :render404


  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !!session[:user_id]
  end

  def admin?
    !!current_user.try(:admin)
  end

  def admin_authentication
    unless admin?
      redirect_to root_path
    end
  end

  def set_default_params
    params[:term] ||= TERM
    params[:year] ||= YEAR
  end

  def check_presence_of_name
    if signed_in? && current_user.name.nil?
      redirect_to set_name_path
    end
  end
  
  def check_setting
    if signed_in?
      unless current_user.setting
        redirect_to new_settings_path
      end
    end
  end

  # Ajaxのときにnoticeをヘッダーに出す
  def flash_to_headers
    return unless request.xhr?

    response.headers['flash-error'] = flash[:error] if flash[:error].present?
    response.headers['flash-notice'] = flash[:notice] if flash[:notice].present?

    flash.discard
  end
  
  def render404(exception=nil)
    message = exception ? exception.message : "RoutingError"
    logger.info "Rendering 404: #{message}"
    
    render :template => 'statics/404', :status => 404
  end
end
