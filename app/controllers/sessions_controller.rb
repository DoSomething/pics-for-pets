class SessionsController < ApplicationController
  include Services

  def new
  end

  def create
    username = params[:session][:username]
    password = params[:session][:password]

    login_response = Services.login(username, password)

    # TODO - NEED TO ADD VERIFICATION THAT LOGIN WAS SUCCESSFUL
    session[:drupal_session_id]   = login_response['sessid']
    session[:drupal_session_name] = login_response['session_name']

    # NOTE - THIS IS A PLACEHOLDER CHECK FOR NOW
    if username && password
      redirect_to :root
    else
      render 'new', :flash.now[:message]= 'login failed'
    end
  end

  def destroy
    session[:drupal_session_id] = nil
    session[:drupal_session_name] = nil

    redirect_to :login, :flash => { :message => 'logout successful' }
  end

end
