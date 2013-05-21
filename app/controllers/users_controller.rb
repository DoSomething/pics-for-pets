class UsersController < ApplicationController
  include Services

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    login_response = Services.login(@user.username, @user.password)

    session[:drupal_session_id]   = login_response['sessid']
    session[:drupal_session_name] = login_response['session_name']

    flash[:message] = 'Login successful'
    # TODO - ADD FLASH MESSAGE VERIFYING LOGIN SUCCESS
    redirect_to :controller => 'posts', :action => 'show'
  end

  def register
    @user = User.new(params[:user])
    
    # TODO - CALL USER REGISTRATION METHOD
   
  end

end

