class LogsController < ApplicationController
  include Services

  def new
    @user = User.new
  end

  # /login
  def create
    @user = User.new(params[:user])

    login_response = Services.login(@user.username, @user.password)

    session[:drupal_session_id]   = login_response['sessid']
    session[:drupal_session_name] = login_response['session_name']

    # TODO - CHECK SESSION STATE FIRST
    redirect_to :root, :flash => { :message => 'login successful' }
  end

  def show
  end

  # /logout
  def out
    session[:drupal_session_id] = nil
    session[:drupal_session_name] = nil

    # TODO - CHECK SESSION STATE FIRST
    redirect_to :login, :flash => { :message => 'logout successful'}
  end

end
