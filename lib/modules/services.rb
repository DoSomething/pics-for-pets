require 'httparty'

module Services

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
