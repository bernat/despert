Intranet::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.serve_static_assets = false


  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  config.action_controller.cache_store = :file_store, "#{Rails.root}/public/cached/"

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :test

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # apanyo temporal degut a que en produccio no aconseguim que agafi el locale :ca by default
  config.i18n.locale = config.i18n.default_locale

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
