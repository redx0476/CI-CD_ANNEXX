require "active_support/core_ext/integer/time"
require "solid_queue"
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  # Staging environment is similar to production but with more debugging capabilities

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are enabled for staging (unlike production).
  config.consider_all_requests_local = ENV.fetch("STAGING_LOCAL_REQUESTS", "false") == "true"

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for staging
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.hour.to_i}" }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://staging-assets.example.com"

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :staging

  # Assume SSL but be more flexible than production
  config.assume_ssl = ENV.fetch("STAGING_ASSUME_SSL", "false") == "true"

  # Force SSL only if explicitly enabled
  config.force_ssl = ENV.fetch("FORCE_SSL", "false") == "true"

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # More verbose logging for staging
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Log deprecations in staging for debugging
  config.active_support.report_deprecations = true

  # Use solid_cache_store for staging (same as production)
  config.cache_store = :solid_cache_store

  # Use solid_queue for Active Job in staging
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }
  
  # Configure solid_cable for staging (after initialization)
  config.after_initialize do
    if defined?(SolidCable) && Rails.application.config.respond_to?(:solid_cable)
      Rails.application.config.solid_cable.connects_to = { database: { writing: :cable } }
    end
  end

  # Email configuration for staging
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false

  # Set host to be used by links generated in mailer templates.
  config.action_mailer.default_url_options = { 
    host: ENV.fetch("STAGING_HOST", "staging.example.com"),
    protocol: ENV.fetch("FORCE_SSL", "false") == "true" ? "https" : "http"
  }

  # Use letter_opener for email testing in staging
  config.action_mailer.delivery_method = :letter_opener if defined?(LetterOpener)

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Show more attributes for inspections in staging (helpful for debugging).
  config.active_record.attributes_for_inspect = :all

  # Enable DNS rebinding protection but be more permissive than production
  # config.hosts = [
  #   "staging.example.com",
  #   /.*\.staging\.example\.com/,
  #   "localhost"  # Allow localhost for staging
  # ]

  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # Staging-specific configurations
  # Enable staging banner or features
  config.staging_mode = true
  
  # Allow web console in staging if needed
  # config.web_console.whitelisted_ips = ['0.0.0.0/0'] if defined?(WebConsole)
  
  # Enable bullet gem in staging for N+1 query detection if available
  if defined?(Bullet)
    config.after_initialize do
      Bullet.enable = true
      Bullet.alert = false
      Bullet.bullet_logger = true
      Bullet.console = false
      Bullet.rails_logger = true
    end
  end
end
