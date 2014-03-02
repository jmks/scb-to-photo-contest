class ContactMailer < ActionMailer::Base
  default :from => ENV["GMAIL_USERNAME"]

  def contact email, text
    @email, @text, @time = email, text, Time.now

    mail :to => ENV["GMAIL_USERNAME"], :subject => "Photo Contest Inquiry"
  end
end