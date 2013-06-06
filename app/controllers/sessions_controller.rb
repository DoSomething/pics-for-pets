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
        User.login(session, @user['uid'], username, password)
        if User.logged_in?
          flash[:message] = "You've logged in successfully!"
          redirect_to :root
        else
          flash[:error] = 'Oh no! Something went wrong with your login.  Try again.'
          render :new
        end
      else
        @user = User.create({
          :email => username,
          :fbid => 0,
        }, username, password)

        if User.created?
          User.login(session, @user.uid, username, password)
          if User.logged_in?
            flash[:message] = "You've logged in succesfully!"
            redirect_to :root
          else
            flash[:error] = "Oh no! Something went wrong with your login.  Try again."
            redirect_to :login
          end
        else
          flash[:error] = "Invalid username / password"
          redirect_to :login
        end
      end
    elsif form == 'register'
      @user = User.register(password, email, 0, first, last, cell, "#{month}/#{day}/#{year}")
      if User.registered?
        User.login(session, @user.uid, email, password)
        if User.logged_in?
          flash.now[:message] = 'Super! You\'ve registered successfully' + " #{response}"
          redirect_to :root
        else
          flash.now[:error] = 'Oh no! Something went wrong while logging you in.  Try again?'
          redirect_to :login
        end
      else
        flash.now[:error] = "A user with that account already exists."
        redirect_to :login
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
    redirect_to :login, :flash => { :message => 'Log out successful' }
  end
end
