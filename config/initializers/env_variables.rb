if Rails.env.development?
  ENV['facebook_app_id'] = '140309336115918'
  ENV['facebook_secret'] = 'c253a1e407dca2ec4f3bcba83ecb1296'
elsif Rails.env.production?
  ENV['facebook_app_id'] = '105775762330'
  ENV['facebook_secret'] = '68e767e16e139277b1e7d2e2ba16a4f6'
end