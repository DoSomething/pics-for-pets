class SessionsController < ApplicationController
  include Services
  include SessionsHelper

  before_filter :is_authenticated, :only => :new
  layout 'gate'

  def new
  end

  def create
    username = params[:session][:username]
    password = params[:session][:password]

    login_response = Services::Auth.login(username, password)

    if login_response.kind_of?(Array)
      flash.now[:error] = 'wtf? try again'
      render :new
    elsif login_response.kind_of?(Hash)
      session[:drupal_user_id]      = login_response['user']['uid']
      session[:drupal_user_role]    = login_response['user']['roles']
      session[:drupal_session_id]   = login_response['sessid']
      session[:drupal_session_name] = login_response['session_name']

      flash[:message] = 'yaaaahs! - you\'ve logged in successfully'
      redirect_to :root
    end
  end

  def fboauth
    auth = env['omniauth.auth']['extra']['raw_info']
    if handle_auth(auth)
      flash[:message] = "You are now connected through Facebook!"
      redirect_to :root
    end
  end

  def destroy
    reset_session

    redirect_to :login, :flash => { :message => 'logout successful' }
  end

end
