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
      if @user = User.exists?(nil, username)
        User.login(session, @user['uid'])
        if User.logged_in?
          flash[:message] = 'super! - you\'ve logged in successfully' + " #{response}"
          redirect_to :root
        else
          flash[:message] = 'Oh no! Something went wrong with your login.  Try again.'
          render :new
        end
      else
        response = Services::Auth.login(username, password)
        if response.code == 200 && response.kind_of?(Hash)
          @user = User.new({
            :email => username,
            :fbid => 0,
            :uid => response['user']['uid'],
            :is_admin => response['user']['roles'].values.include?('administrator')
          })

          if @user.save
            User.login(session, response['user']['uid'])
            if User.logged_in?
              flash[:message] = 'super! - you\'ve logged in successfully' + " #{response}"
              redirect_to :root
            end
          end
        else
          # you are drunk; go home
          flash.now[:error] = 'wtf? try again -- user login failed' + " #{response}"
          render :new
        end
      end
    elsif form == 'register'
      @user = User.register(password, email, first, last, cell, "#{month}/#{day}/#{year}")
      if User.registered?
        User.login(session, @user.id)
        if User.logged_in?
          flash.now[:message] = 'Super! You\'ve registered successfully' + " #{response}"
          redirect_to :root
        else
          flash.now[:message] = 'Oh no! Something went wrong while logging you in.  Try again?'
          render :new
        end
      else
        flash.now[:message] = 'Oh no! Something went wrong while registering you.  Try again?'
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
