class Mailer < ActionMailer::Base
  default from: "Hilary at DoSomething.org <animals@dosomething.org>"

  def signup(email)
  	mail(:to => email, :subject => "Thanks for signing up for Pics for Pets!")
  end
end
