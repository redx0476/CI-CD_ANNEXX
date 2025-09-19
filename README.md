# ANNEXX - Rails 8 Multi-Database Application

A modern Rails 8 application with comprehensive multi-database setup supporting cache, queue, and cable databases across all environments.

## 🚀 Quick Start

```bash
# Clone and setup
git clone <repository-url>
cd ANNEXX

# Install dependencies
bundle install

# Setup all databases for development
./bin/multi-db-setup

# Start the application
bin/rails server
```

## 📋 Table of Contents

- [System Requirements](#system-requirements)
- [Multi-Database Architecture](#multi-database-architecture)
- [Environment Configuration](#environment-configuration)
- [Setup Instructions](#setup-instructions)
- [Database Management](#database-management)
- [Environment Switching](#environment-switching)
- [Available Scripts](#available-scripts)
- [CI/CD Pipeline](#cicd-pipeline)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)

## 🔧 System Requirements

- **Ruby**: 3.4.6+
- **Rails**: 8.0.2+
- **PostgreSQL**: 13+
- **Node.js**: 18+ (for asset pipeline)

### Required Gems
- `solid_cache` - Database-backed caching
- `solid_queue` - Database-backed job processing
- `solid_cable` - Database-backed Action Cable
- `tailwindcss-rails` - CSS framework
- `dotenv-rails` - Environment variable management

## 🗄️ Multi-Database Architecture

ANNEXX uses a multi-database architecture with separate databases for different concerns:

| Environment | Primary | Cache | Queue | Cable |
|------------|---------|-------|-------|-------|
| **Development** | `annexx_development` | `annexx_development_cache` | `annexx_development_queue` | `annexx_development_cable` |
| **Test** | `annexx_test` | `annexx_test_cache` | `annexx_test_queue` | `annexx_test_cable` |
| **Staging** | `annexx_staging` | `annexx_staging_cache` | `annexx_staging_queue` | `annexx_staging_cable` |
| **Production** | `annexx_production` | `annexx_production_cache` | `annexx_production_queue` | `annexx_production_cable` |

### Database Purposes
- **Primary**: Application data, models, business logic
- **Cache**: Solid Cache storage for performance
- **Queue**: Solid Queue jobs and background processing
- **Cable**: Action Cable messages and WebSocket data

## ⚙️ Environment Configuration

The application uses environment-specific `.env` files for configuration:

### Environment Files
- `.env` - Common settings and defaults
- `.env.development` - Development-specific settings  
- `.env.test` - Test environment settings
- `.env.staging` - Staging environment settings
- `.env.production` - Production environment settings

### Key Environment Variables
```bash
# Database Configuration
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=your_password
DATABASE_HOST=localhost
DATABASE_PORT=5432

# Production Secrets
ANNEXX_DATABASE_PASSWORD=production_password
ANNEXX_STAGING_DATABASE_PASSWORD=staging_password
SECRET_KEY_BASE=your_secret_key

# Staging Configuration  
STAGING_HOST=staging.example.com
FORCE_SSL=false
```

## 🛠️ Setup Instructions

### 1. Initial Setup
```bash
# Install Ruby dependencies
bundle install

# Create environment files (optional - defaults provided)
cp .env.example .env  # If you want to customize

# Setup all databases and migrations
./bin/multi-db-setup

# Or drop and recreate all databases
./bin/multi-db-setup --drop
```

### 2. Development Setup
```bash
# Switch to development environment
./bin/env-switch development

# Create and migrate databases
bin/rails db:create
bin/rails db:migrate

# Start development server
bin/rails server
```

### 3. Staging Setup
```bash
# Switch to staging environment
./bin/env-switch staging

# Set staging database password in .env.staging
echo "ANNEXX_STAGING_DATABASE_PASSWORD=your_staging_password" >> .env.staging

# Create and migrate databases
RAILS_ENV=staging bin/rails db:create
RAILS_ENV=staging bin/rails db:migrate

# Start staging server
RAILS_ENV=staging bin/rails server -p 3001
```

### 4. Test Setup
```bash
# Switch to test environment
./bin/env-switch test

# Setup test databases
RAILS_ENV=test bin/rails db:create
RAILS_ENV=test bin/rails db:migrate

# Run tests
bin/rails test
```

## 🗃️ Database Management

### Available Rake Tasks
```bash
# Multi-database management
bin/rails multi_db:status           # Show all database connections
bin/rails multi_db:create_all       # Create all databases
bin/rails multi_db:migrate_all      # Migrate all databases  
bin/rails multi_db:setup_all        # Complete setup
bin/rails multi_db:drop_all         # Drop all databases
bin/rails multi_db:reset_all        # Reset all (dev/test only)

# Standard Rails tasks
bin/rails db:create                 # Create primary database
bin/rails db:migrate                # Migrate primary database
bin/rails db:seed                   # Seed database
```

### Manual Database Operations
```bash
# Create specific environment databases
RAILS_ENV=staging bin/rails db:create

# Load solid component schemas
bin/rails db:schema:load:cache
bin/rails db:schema:load:queue  
bin/rails db:schema:load:cable

# Check database status
bin/rails multi_db:status

# Drop and recreate databases (DESTRUCTIVE)
./bin/multi-db-setup --drop          # With confirmation
./bin/multi-db-setup --drop --force  # Skip confirmation
bin/rails multi_db:drop_all          # Drop via Rake task
```

## 🔄 Environment Switching

Use the built-in environment switcher:

```bash
# Switch environments
./bin/env-switch development
./bin/env-switch test
./bin/env-switch staging
./bin/env-switch production

# Check available environments
./bin/env-switch
```

This script:
- ✅ Copies environment-specific `.env` file to `.env`
- ✅ Sets correct `RAILS_ENV`
- ✅ Backs up current configuration
- ✅ Provides clear feedback

## 📜 Available Scripts

### Setup Scripts
- `./bin/multi-db-setup` - Complete multi-database setup
- `./bin/staging-setup` - Staging-specific setup
- `./bin/env-switch` - Environment switching

### Standard Rails Scripts
- `bin/rails console` - Rails console
- `bin/rails server` - Start server
- `bin/rails generate` - Generators
- `bin/brakeman` - Security analysis
- `bin/rubocop` - Code linting

## 🚦 CI/CD Pipeline

The application includes GitHub Actions workflows:

### Workflows (`.github/workflows/`)
- `ci.yml` - Continuous Integration
  - Ruby security scanning (Brakeman)
  - JavaScript security audit (Importmap)  
  - Code linting (RuboCop)

### CI Configuration
- **Ruby Version**: From `.ruby-version`
- **Bundler Cache**: Enabled
- **Security Scans**: Automated
- **Code Quality**: Enforced

## 🚀 Deployment

### Environment-Specific Deployment

#### Staging Deployment
```bash
# Prepare staging
./bin/env-switch staging
./bin/staging-setup

# Deploy to staging server
RAILS_ENV=staging bin/rails assets:precompile
RAILS_ENV=staging bin/rails db:migrate
```

#### Production Deployment
```bash
# Set production secrets
export ANNEXX_DATABASE_PASSWORD="your_production_password"
export SECRET_KEY_BASE="your_secret_key"

# Deploy
RAILS_ENV=production bin/rails assets:precompile
RAILS_ENV=production bin/rails db:migrate
```

### Using Kamal (Docker Deployment)
The application is Kamal-ready:
```bash
kamal setup    # Initial deployment
kamal deploy   # Deploy updates
```

## 🔍 Troubleshooting

### Common Issues

#### Database Connection Errors
```bash
# Check database status
bin/rails multi_db:status

# Verify environment variables
env | grep DATABASE

# Test connection
bin/rails db:version
```

#### Environment Loading Issues
```bash
# Check environment file loading
bin/rails runner "puts ENV['RAILS_ENV']"

# Verify dotenv loading
bin/rails runner "puts 'Environment loaded successfully'"
```

#### Multi-Database Issues
```bash
# Reset and recreate all databases (dev/test only)
bin/rails multi_db:reset_all

# Check migration status
bin/rails db:migrate:status
```

### Error Solutions

#### `solid_cable` Configuration Error
- Ensure `solid_cable` gem is installed
- Check `config/cable.yml` has correct environment
- Verify database exists and is migrated

#### Missing Environment Variables
- Check `.env` files exist and are loaded
- Verify environment-specific variables
- Use `./bin/env-switch` to set correct environment

#### Database Permission Issues
- Verify PostgreSQL user permissions
- Check `DATABASE_USERNAME` and `DATABASE_PASSWORD`
- Ensure PostgreSQL is running

## 📚 Additional Resources

### File Structure
```
ANNEXX/
├── bin/
│   ├── multi-db-setup      # Multi-database setup script
│   ├── staging-setup       # Staging setup script
│   └── env-switch          # Environment switcher
├── config/
│   ├── environments/       # Environment-specific configs
│   ├── initializers/       # Custom initializers
│   ├── database.yml        # Multi-database configuration
│   ├── cable.yml          # Action Cable configuration
│   ├── cache.yml          # Cache configuration
│   └── queue.yml          # Queue configuration
├── db/
│   ├── cache_migrate/     # Cache database migrations
│   ├── queue_migrate/     # Queue database migrations
│   └── cable_migrate/     # Cable database migrations
└── .env*                  # Environment configuration files
```

### Key Configuration Files
- `config/database.yml` - Multi-database setup
- `config/environments/` - Environment-specific settings
- `config/initializers/multi_database.rb` - Database connections
- `lib/tasks/multi_db.rake` - Database management tasks

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Run tests (`bin/rails test`)
4. Run linting (`bin/rubocop`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
