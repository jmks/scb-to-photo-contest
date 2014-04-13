# Gmail mail settings
ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
    :address              => 'smtp.gmail.com',
    :port                 => 587,
    :domain               => 'scbtorontophotos.com',
    :authentication       => :login,
    :user_name            => ENV["GMAIL_USERNAME"],
    :password             => ENV["GMAIL_PASSWORD"]
}