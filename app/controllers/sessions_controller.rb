class SessionsController < ApplicationController
  include Services

  before_filter :is_authenticated, :only => :new
  layout 'gate'

  def new
  end

  def create
    # @TODO - IF AUTHENTICATED, THROW 500

    # form
    form     = params[:form]

    # login
    username = params[:session][:username]
    password = params[:session][:password]

    # registration
    email    = params[:session][:email]
    first    = params[:session][:first]
    last     = params[:session][:last]
    cell     = params[:session][:cell]
    month    = params[:session][:month]
    day      = params[:session][:day]
    year     = params[:session][:year]

    if form == 'login'
      services_response = Services::Auth.login(username, password)
    elsif form == 'register'
      services_response = Services::Auth.register(password, email, first, last, cell, month, day, year)
    end

    if !services_response[:user][:uid].empty? && form == 'register'
      Services::Auth.login(username, password)
    end

    if services_response.kind_of?(Array)
      flash.now[:error] = 'wtf? try again'
      render :new
    elsif services_response.kind_of?(Hash)
      # @TODO - REMOVE SESSION_NAME & SESSION_ID
      session[:drupal_user_id]      = services_response['user']['uid']
      session[:drupal_user_role]    = services_response['user']['roles']
      session[:drupal_session_id]   = services_response['sessid']
      session[:drupal_session_name] = services_response['session_name']
      # Log user in if they were successfully registered
      flash[:message] = 'yaaaahs! - you\'ve logged in successfully'
      redirect_to :root
    end
  end

  def destroy
    reset_session
    redirect_to :login, :flash => { :message => 'logout successful' }
  end

end
