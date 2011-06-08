ActionMailer::Base.smtp_settings = {
  :address              => APP_CONFIG['mail']['smtp']['address'],
  :port                 => APP_CONFIG['mail']['smtp']['port'],
  :domain               => APP_CONFIG['mail']['smtp']['domain'],
  :user_name            => APP_CONFIG['mail']['account']['user_name'],
  :password             => APP_CONFIG['mail']['account']['password'],
  :authentication       => APP_CONFIG['mail']['smtp']['authentication'],
  :enable_starttls_auto => APP_CONFIG['mail']['smtp']['enable_starttls_auto']
}

ActionMailer::Base.default_url_options[:host] = APP_CONFIG['hostname']
