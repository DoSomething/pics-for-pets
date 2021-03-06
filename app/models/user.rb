class User < ActiveRecord::Base
  attr_accessible :email, :fbid, :uid, :is_admin

  include Services

  @@registered = false
  @@logged_in = false
  @@created = false
  @@errors = []

  ##
  # Registers a user on Drupal and within the API service.
  #
  # @param string password
  #   A password to give to the user.  If nil, will generate a password
  #   automatically.
  #
  # @param string email
  #   A valid email address.
  #
  # @param string first
  #   A valid first name.
  #
  # @param string last
  #   A valid last name.
  #
  # @param string cell
  #   A valid phone number.
  #
  # @param string birthday
  #   A birthday in format MM/DD/YYYY (e.g. 10/05/1984)
  ##
  def self.register(password, email, fbid, first, last, cell, birthday, is_admin = false)
    bday = Date.strptime(birthday, '%m/%d/%Y')
    response = Services::Auth.register(password, email, first, last, cell, bday.month, bday.day, bday.year)
    if response.code == 200 && response.kind_of?(Hash) && response.parsed_response.first != "An account with that username already exists"
      login = Services::Auth.login(email, password)
      if login.code == 200 && login.kind_of?(Hash)
        @user = User.new({
          :email => email,
          :fbid => fbid,
          :uid => login['user']['uid'],
          :is_admin => login['user']['roles'].values.include?('administrator')
        })
        begin
          @user.save
          @@registered = true
          @user
        rescue
          @@registered = false
          @@errors.push 'There was an error with creating your account.'
        end
      end
    else
      @@errors.push response[0]
      @@registered = false
    end
  end

  # Log in a user if they exist.
  #
  # @param object session
  #   The session object, so we can log the user in.
  # @param integer uid
  #   The user ID to log in.
  # @param string username
  #   The username (or email) of the person trying to log in.
  # @param string password
  #   The password of the user.
  def self.login(session, uid, username, password)
    if @exists = self.exists?(uid)
      response = Services::Auth.login(username, password)
      if response.code == 200 && response.kind_of?(Hash)
        session[:drupal_user_id]   = response['user']['uid']
        session[:drupal_user_role] = response['user']['roles']
        @@logged_in = true
        response
      else
        @@logged_in = false
        response
      end
    else
      @@logged_in = false
      response
    end
  end

  # Create a user within the rails environment.
  #
  # @param Hash parameters
  #   A hash of parameters to send to User.new (creates the user within rails)
  # @param string username
  #   The username (or email) of the person to create.
  # @param string password
  #   The password of the person to create.
  def self.create(parameters, username, password)
    response = Services::Auth.login(username, password)
    if response.code == 200 && response.kind_of?(Hash)
      parameters[:uid] = response['user']['uid']
      parameters[:is_admin] = response['user']['roles'].values.include?('administrator')

      @user = User.new(parameters)

      if @user.save
        @@created = true
        @user
      else
        @@created = false
      end
    else
      @@created = false
    end
  end

  # Did it successfully create?
  def self.created?
  	@@created || false
  end

  # Does a user already exist within the rails database?
  #
  # @param integer uid
  #   The user ID of the person to check against.
  # @param string email (nil)
  #   The (optional) email of the person to check.
  def self.exists?(uid, email = nil)
    if !uid.nil?
      @c = User.find_by_uid(uid)
    elsif !email.nil?
      @c = User.find_by_email(email)
    end

    if @c.nil?
      false
    else
      { 'uid' => @c.uid }
    end
  end

  # Is the user an administrator?
  def self.admin?(uid)
    u = User.find_by_uid(uid)
    !u.is_admin.nil?
  end

  # Is the user logged in? (this is set to true from the login method)
  def self.logged_in?
    @@logged_in || false
  end

  # Is the user registered? (this is set to true from the register method)
  def self.registered?
    @@registered || false
  end

  # Was there an error while setting up everything?
  def self.error?
    if @errors.nil?
      false
    else
      @errors.is_a? Array && @errors.length > 0
    end
  end
end
