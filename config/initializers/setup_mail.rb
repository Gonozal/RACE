ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'arne-link.de',
  :user_name            => 'link.arne@googlemail.com',
  :password             => '193746825',
  :authentication       => 'plain',
  :enable_starttls_auto => true
}