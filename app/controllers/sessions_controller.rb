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
      if res = ruby_user_exists(username, nil)
        roles = { 1 => 'authenticated user' }
        if res['is_admin']
          roles = { 1 => 'administrator', 2 => 'authenticated user' }
        end

        Services::Auth.authenticate(session, res['uid'], roles)
        flash[:message] = 'super! - you\'ve logged in successfully' + " #{response}"
        redirect_to :root
      else
        response = Services::Auth.login(username, password)
        if response.code == 200 && response.kind_of?(Hash)
          if ruby_add_user(username, 0, response['user']['uid'], response['user']['roles'].values.include?('administrator'))
            Services::Auth.authenticate(session, response['user']['uid'], response['user']['roles'])
            flash[:message] = 'super! - you\'ve logged in successfully' + " #{response}"
            redirect_to :root
          end
        else
          # you are drunk; go home
          flash.now[:error] = 'wtf? try again -- user login failed' + " #{response}"
          render :new
        end
      end
    elsif form == 'register'
      response = Services::Auth.register(password, email, first, last, cell, month, day, year)
      if response.code == 200 && response.kind_of?(Hash)
        response = Services::Auth.login(email, password)
        if response.code == 200 && response.kind_of?(Hash)
          if ruby_add_user(email, 0, response['user']['uid'], response['user']['roles'].values.include?('administrator'))
            # super -- proceed
            Services::Auth.authenticate(session, response['user']['uid'], response['user']['roles'])
            flash[:message] = 'super! - you\'ve registered successfully' + " #{response}"
            redirect_to :root
          end
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
    else
      flash.now[:error] = 'Auth failed! Please try again, or try registering through the form below.'
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to :login, :flash => { :message => 'logout successful' }
  end

end
