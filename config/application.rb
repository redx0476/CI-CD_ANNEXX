require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "rails/all"

# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Annexx
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        # view_specs: false,
        # helper_specs: false,
        # routing_specs: false,
        # request_specs: false,
        controller_specs: true
      # If you want to use YAML fixtures (not FactoryBot), do NOT set fixture_replacement
      # If you prefer FactoryBot later, comment the above 'fixtures: true' and use:
      # g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
