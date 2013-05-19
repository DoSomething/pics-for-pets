require 'httparty'

class Services
  include HTTParty
  base_uri 'www.dosomething.org:443' # Force HTTPS connection via port 443

  def self.login(username, password)
    post('/rest/user/login.json', :body => { :username => username, :password => password })
  end

  def self.logout(username, password)
    post('/rest/user/logout.json', :body => { :username => username, :password => password })
  end

  # TODO - CREATE USER REGISTRATION METHOD

end

class UsersController < ApplicationController

  def new
    @user = User.new
  end

  # GET /create
  def create
    @user = User.new(params[:user])

    login_response = Services.login(@user.username, @user.password)

    puts login_response

    #redirect_to :root
  end

  def register
    @user = User.new(params[:user])
    
    # TODO - CALL USER REGISTRATION METHOD
   
  end

end

