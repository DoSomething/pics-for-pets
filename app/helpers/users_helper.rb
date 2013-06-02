module UsersHelper
  include Services

  def ruby_user_exists(email, fbid)
    @user = User.where('email = ? or fbid = ?', email, fbid).first

    if !@user.nil?
      { 'uid' => @user.uid, 'is_admin' => @user.is_admin }
    else
      false
    end
  end

  def drupal_user_exists(email)
    response = Services::Auth.check_exists(email)
    if !response.first['uid'].nil?
      # The user exists.  Are they an admin?
      is_admin = Services::Auth.check_admin(email)
      roles = { 1 => 'authenticated user'}

      validates_admin = false
      if !is_admin.first.nil?
        validates_admin = true
        # Fake the admin array.
        if !is_admin.first['uid'].nil?
          roles = { 1 => 'administrator', 2 => 'authenticated user' }
        end
      end

      Services::Auth.authenticate(session, response.first['uid'], roles)
      { 'uid' => response.first['uid'], 'is_admin' => validates_admin }
    else
      false
    end
  end

  def ruby_add_user(email, fbid, uid, is_admin)
    @user = User.new
    @user.uid = uid
    @user.email = email
    @user.fbid = fbid
    @user.is_admin = is_admin

    if @user.save
      true
    else
      false
    end
  end
end
