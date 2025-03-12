class ApplicationMailer < ActionMailer::Base
  default from: Settings.smtp_settings.user_name
  layout "mailer"
end
