ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "127.0.0.1:3000",
  :user_name            => "LeradoMendar",
  :password             => "193746825",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
