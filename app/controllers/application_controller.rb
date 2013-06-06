class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper

  def is_authenticated
    if authenticated?
      redirect_to :root
    end
  end

  def is_not_authenticated
    unless authenticated? || request.format.symbol == :json || params[:bypass] === true
      redirect_to :login
      false
    end
  end

  def admin
    unless admin?
      flash[:error] = "error: this page is available to admin only - login below"
      redirect_to :login
      false
      # TODO - SHOULD WE LOG USERS OUT WHEN THEY LAND HERE? SESSION SHOULD BE EMPTY AT THIS POINT
    end
  end

  def verify_api_key
   if params[:key].nil?
     render :json => { :errors => "Invalid API key." }, :status => :forbidden
   else
     @key = ApiKey.find_by_key(params[:key])
     if @key.nil?
       render :json => { :errors => "Invalid API key." }, :status => :forbidden
     end
   end
  end

  alias :std_redirect_to :redirect_to
  def redirect_to(*args)
    flash.keep
    std_redirect_to *args
  end
end
