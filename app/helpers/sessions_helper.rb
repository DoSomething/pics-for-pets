module SessionsHelper
  include UsersHelper
  include Services

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

    # CHECK USERS TO SEE IF E/FBID EXISTS
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
      end
      #else
      	#ruby_register_user()
      #end
    end
  end
end
