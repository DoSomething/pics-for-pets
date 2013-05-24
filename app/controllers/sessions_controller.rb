class SessionsController < ApplicationController
  include Services

  def new
  end

  def create
    username = params[:session][:username]
    password = params[:session][:password]

    login_response = Services.login(username, password)

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

  def destroy
    session[:drupal_session_id] = nil
    session[:drupal_session_name] = nil

    redirect_to :login, :flash => { :message => 'logout successful' }
  end

end
