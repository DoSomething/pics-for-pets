class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  helper_method :authenticated?, :admin?

  def authenticated?
    false
  end

  def admin?
    false
  end

  def authorize
    unless admin?
      flash[:error] = "error: this page is available to admin only - login below"
      redirect_to :login
      false
    end
  end
end
