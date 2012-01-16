class AccountMailer < ActionMailer::Base
  @queue = :mail_queue
  default :from => "RACE <account@race.com>"
  
  # As this class is a mailer as well as a worker we need the perform method
  def self.perform(method, *args)
    self.send(method, *args).deliver
  end
  
  # Relays the given method to Resque with self as the class to perform the work
  # (see #self.perform)
  def send_async(method, *args)
    Resque.enqueue(self.class, method, *args)
  end
  
  # send the password_reset_mail
  def password_reset_mail(account)
    @account = account
    mail(:to => "#{@account['name']} <#{@account['email']}>", :subject => "Your password reset link")
  end
end