module SessionsHelper
  include UsersHelper
  include Services

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
        date = Date.strptime(auth['birthday'], '%m/%d/%Y')
        response = Services::Auth.register(password, auth['email'], auth['first_name'], auth['last_name'], '', date.month, date.day, date.year)
        if response.code == 200 && response.kind_of?(Hash)
          response = Services::Auth.login(auth['email'], password)
          if response.code == 200 && response.kind_of?(Hash)
            # super -- proceed
            if (ruby_add_user(auth['email'], auth['id'], response['user']['uid'], response['user']['roles'].values.include?('administrator')))
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
end
