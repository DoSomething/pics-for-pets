class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  helper_method :authenticated?, :admin?

  def authenticated?
    (session[:drupal_user_role] && session[:drupal_user_role].values.include?('authenticated user')) ? true : false
  end

  def user
    unless authenticated?
      flash[:error] = "you need to log in, kid"
      redirect_to :login
      false
    end
  end

  def admin?
    (session[:drupal_user_role] && session[:drupal_user_role].values.include?('administrator')) ? true : false
  end

  def admin
    unless admin?
      flash[:error] = "error: this page is available to admin only - login below"
      redirect_to :login
      false
      # TODO - SHOULD WE LOG USERS OUT WHEN THEY LAND HERE? SESSION SHOULD BE EMPTY AT THIS POINT
    end
  end
end
