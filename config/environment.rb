# Load the rails application
require File.expand_path('../application', __FILE__)

APP_CONFIG = YAML.load_file("#{Rails.root}/config/app.yml")[Rails.env]

# Initialize the rails application
Intranet::Application.initialize!
