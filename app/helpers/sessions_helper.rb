module SessionsHelper
  include UsersHelper
  include Services
  include Mailchimp

  # Handles Facebook authentication.
  # @param hash auth
  #   A hash of data returned from Facebook.
  def handle_auth(auth)
    ##
    # Returned from Facebook (actual keys):
    # email
    # first_name
    # last_name
    # gender
    # id (fb)
    # birthday
    ##

    # CHECK USERS TO SEE IF FBID EXISTS
    if res = ruby_user_exists(auth['email'], auth['id'])
      roles = { 1 => 'authenticated user' }
      if res['is_admin']
        roles = { 1 => 'administrator', 2 => 'authenticated user' }
      end

      Services::Auth.authenticate(session, res['uid'], roles)
      true
    else
      # SERVICES CALL TO CHECK USERS TABLE FOR EMAIL
      if res = drupal_user_exists(auth['email'])
        if ruby_add_user(auth['email'], auth['id'], res['uid'], res['is_admin'])
          true
        end
      # REGISTER USER
      else
        password = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
        if auth['birthday'].nil?
          date = Date.parse('5th October 2000')
        else
          date = Date.strptime(auth['birthday'], '%m/%d/%Y')
        end

        response = Services::Auth.register(password, auth['email'], auth['first_name'], auth['last_name'], '', date.month, date.day, date.year)
        if response.code == 200 && response.kind_of?(Hash)
          response = Services::Auth.login(auth['email'], password)
          if response.code == 200 && response.kind_of?(Hash)
            # super -- proceed
            if (ruby_add_user(auth['email'], auth['id'], response['user']['uid'], response['user']['roles'].values.include?('administrator')))
              handle_mc(auth['email'], nil)
              Services::Auth.authenticate(session, response['user']['uid'], response['user']['roles'])
              true
            else
              false
            end
          else
            false
          end
        else
          false
        end
      end
    end
  end

  # Sends MailChimp / Mobile Commons messages to a user.
  #
  # @param string email
  #   The email to send the message to.
  # @param string mobile
  #   A valid phone number to send a txt to.
  ##
  def handle_mc(email = nil, mobile = nil)
    if !email.nil?
      # MailChimp PicsforPets2013
      Services::MailChimp.subscribe(email, 'PicsforPets2013')
      Services::Mandrill.email(email, 'PicsforPets_2013_Signup', 'Thanks for signing up for Pics for Pets!')
    end

    if !mobile.nil?
      # Mobile Commons 158551
      Services::MobileCommons.subscribe(mobile, 158551)
    end
  end
end
