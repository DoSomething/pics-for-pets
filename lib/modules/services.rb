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

    def self.register(password, email, first, last, cell, month, day, year)
      birthday = "#{month}/#{day}/#{year}"
      post('/rest/user/register.json', :body => {
        'profile_main[field_user_first_name][und][0][value]' => first,
        'profile_main[field_user_last_name][und][0][value]' => last,
        'mail' => email,
        'profile_main[field_user_mobile][und][0][value]' => cell,
        'pass'  => password,
        'profile_main[field_user_birthday][und][0][value][date]' => birthday,
        'name'  =>  email, # Set username equal to email
        'profile_main[field_user_official_rules][und]' => 1 # Pass user's acceptance of our official rules
      })
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
