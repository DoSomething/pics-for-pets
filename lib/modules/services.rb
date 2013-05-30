require 'httparty'
require 'gibbon'

module Services
  # Login / out / register methods
  module Auth
    include HTTParty
    base_uri 'www.dosomething.org:443' # Force HTTPS connection via port 443

    def self.login(username, password)
      post('/rest/user/login.json', :body => { :username => username, :password => password })
    end

    def self.logout(username, password)
      post('/rest/user/logout.json', :body => { :username => username, :password => password })
    end

    def self.check_exists(email)
      get('/ruby/users/' + email + '?' + Time.now.to_i.to_s)
    end

    def self.check_admin(email)
      get ('/ruby/users/is_admin/' + email + '?' + Time.now.to_i.to_s)
    end

    def self.authenticate(session, uid, roles={})
      session[:drupal_user_id]      = uid
      session[:drupal_user_role]    = roles
    end
  end

  # MailChimp (email) methods
  module MailChimp
  	@mc = Gibbon.new('cdd0ad8955001739ec42519956312bee-us4')
    def self.subscribe(email, campaign)
      groups = @mc.listInterestGroupings({ :id => 'f2fab1dfd4' })
      gid = ''
      groups.last['groups'].each do |g|
        if g['name'] == campaign
          gid = g['bit']
          break
        end
      end

      @gid = gid
      @campaign = campaign
      mv = { 'GROUPINGS' => {'id' => @gid, 'groups' => @campaign } },
      r = @mc.list_subscribe({
      	:id => 'f2fab1dfd4',
      	:email_address => email,
      	:merge_vars => mv,
      	:email_type => 'html',
      	:double_optin => false,
      	:update_existing => true,
      	:replace_interests => false,
      })
    end
  end

  # Mobile Commons (txt messaging) methods
  module MobileCommons
    include HTTParty
    base_uri 'dosomething.mcommons.com'

    def self.subscribe(mobile, opt_in_path)
      post('/profiles/join', :body => { 'person[phone]' => mobile, 'opt_in_path[]' => opt_in_path })
    end
  end
end