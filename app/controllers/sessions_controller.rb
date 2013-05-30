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

    sess = params[:session]

    # login
    username = sess[:username]
    password = sess[:password]

    # registration
    email    = sess[:email]
    first    = sess[:first]
    last     = sess[:last]
    cell     = sess[:cell]
    month    = sess[:month]
    day      = sess[:day]
    year     = sess[:year]

    # @TODO - PASSWORD VALIDATION CHECK; MINIMUM CHECK ON LENGTH
    # @TODO - ACCEPTABLE RESPONSE TO USER WHO FAILS TO LOG IN
    # @TODO - STOP REDIRECTING TO /SESSIONS
    # @TODO - KEEP FIELDS POPULATED WHEN CONTROLLER ERRORS OUT

    if form == 'login'
      response = Services::Auth.login(username, password)
      if response.code == 200 && response.kind_of?(Hash)
        Services::Auth.authenticate(session, response['user']['uid'], response['user']['roles'])
        flash[:message] = 'super! - you\'ve logged in successfully' + " #{response}"
        redirect_to :root
      else
        # you are drunk; go home
        flash.now[:error] = 'wtf? try again -- user login failed' + " #{response}"
        render :new
      end
    elsif form == 'register'
      response = Services::Auth.register(password, email, first, last, cell, month, day, year)
      if response.code == 200 && response.kind_of?(Hash)
        response = Services::Auth.login(email, password)
        if response.code == 200 && response.kind_of?(Hash)
          # super -- proceed
          Services::Auth.authenticate(session, response['user']['uid'], response['user']['roles'])
          flash[:message] = 'super! - you\'ve registered successfully' + " #{response}"
          redirect_to :root
        else
          # you are drunk; go home
          flash.now[:error] = 'wtf? try again -- user login post reg failed' + " #{response}"
          render :new
        end
      else
        # you are drunk; go home
        flash.now[:error] = "failed to register: #{response[0]}"
        render :new
      end
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
