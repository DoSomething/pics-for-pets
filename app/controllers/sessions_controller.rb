class SessionsController < ApplicationController
  include Services
  include SessionsHelper

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
    elsif login_response.kind_of?(Hash)
      Services::Auth.authenticate(session, login_response['user']['uid'], login_response['user']['roles'])
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
