# Environment-specific configuration loader
# This initializer automatically loads environment-specific .env files

Rails.application.configure do
  # Get the current Rails environment
  current_env = Rails.env
  
  # Load the environment-specific .env file if it exists
  env_file = Rails.root.join(".env.#{current_env}")
  
  if File.exist?(env_file)
    require 'dotenv'
    Dotenv.load(env_file)
    Rails.logger.info "Loaded environment configuration from .env.#{current_env}"
  else
    Rails.logger.warn "Environment file .env.#{current_env} not found, using default configuration"
  end
  
  # Also load the base .env file for common settings
  base_env_file = Rails.root.join('.env')
  if File.exist?(base_env_file)
    Dotenv.load(base_env_file)
    Rails.logger.info "Loaded base environment configuration from .env"
  end
end
