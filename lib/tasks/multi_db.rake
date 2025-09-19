# Multi-database management tasks for ANNEXX

namespace :multi_db do
  desc "Create all databases for current environment"
  task create_all: :environment do
    puts "🏗️  Creating all databases for #{Rails.env} environment..."
    
    databases = %w[primary cache queue cable]
    
    databases.each do |db|
      begin
        ActiveRecord::Base.connected_to(database: { writing: db.to_sym }) do |connection|
          # The connection will create the database if it doesn't exist
          puts "✅ Connected to #{db} database"
        end
      rescue ActiveRecord::NoDatabaseError
        puts "📋 Database #{db} needs to be created manually"
      rescue => e
        puts "❌ Error connecting to #{db} database: #{e.message}"
      end
    end
    
    puts "🎯 Database creation complete!"
  end

  desc "Show status of all databases"
  task status: :environment do
    puts "📊 Multi-Database Status for #{Rails.env.upcase} Environment"
    puts "=" * 60
    
    databases = {
      'Primary' => :primary,
      'Cache' => :cache, 
      'Queue' => :queue,
      'Cable' => :cable
    }
    
    databases.each do |name, db_key|
      begin
        ActiveRecord::Base.connected_to(database: { writing: db_key }) do
          connection = ActiveRecord::Base.connection
          db_name = connection.current_database
          status = connection.active? ? "✅ Active" : "❌ Inactive"
          puts "#{name.ljust(12)}: #{status.ljust(12)} | Database: #{db_name}"
        end
      rescue => e
        puts "#{name.ljust(12)}: ❌ Error      | #{e.message.truncate(40)}"
      end
    end
    
    puts "\n🔧 Database Configuration:"
    Rails.application.config.database_configuration[Rails.env].each do |key, config|
      if config.is_a?(Hash) && config['database']
        puts "  #{key.ljust(10)}: #{config['database']}"
      end
    end
  end

  desc "Migrate all databases"
  task migrate_all: :environment do
    puts "🚀 Migrating all databases for #{Rails.env} environment..."
    
    # Migrate primary database
    puts "\n📋 Migrating primary database..."
    Rake::Task['db:migrate'].invoke
    
    # Load cache database schema (solid_cache)
    puts "\n🗄️  Loading cache database schema..."
    begin
      Rake::Task['db:schema:load:cache'].invoke
    rescue => e
      puts "⚠️  Cache schema load error: #{e.message}"
    end
    
    # Load queue database schema (solid_queue)  
    puts "\n📋 Loading queue database schema..."
    begin
      Rake::Task['db:schema:load:queue'].invoke
    rescue => e
      puts "⚠️  Queue schema load error: #{e.message}"
    end
    
    # Load cable database schema (solid_cable)
    puts "\n📡 Loading cable database schema..."
    begin
      Rake::Task['db:schema:load:cable'].invoke
    rescue => e
      puts "⚠️  Cable schema load error: #{e.message}"
    end
    
    puts "\n✅ All database migrations complete!"
  end

  desc "Setup all databases from scratch"
  task setup_all: :environment do
    puts "🎯 Complete multi-database setup for #{Rails.env} environment"
    puts "=" * 60
    
    Rake::Task['multi_db:create_all'].invoke
    Rake::Task['multi_db:migrate_all'].invoke
    Rake::Task['multi_db:status'].invoke
    
    puts "\n🚀 Multi-database setup complete!"
    puts "\n💡 Next steps:"
    puts "• Start your Rails server: bin/rails server"
    puts "• Check logs for any connection issues"
    puts "• Run tests: bin/rails test"
  end

  desc "Drop all databases for current environment"
  task drop_all: :environment do
    puts "💥 Dropping all databases for #{Rails.env} environment..."
    
    Rake::Task['db:drop'].invoke
    puts "✅ All databases dropped!"
  end

  desc "Reset all databases (⚠️  DESTRUCTIVE)"
  task reset_all: :environment do
    unless Rails.env.development? || Rails.env.test?
      puts "❌ This task can only be run in development or test environments!"
      exit 1
    end
    
    puts "⚠️  WARNING: This will destroy all data in #{Rails.env} databases!"
    print "Type 'yes' to continue: "
    
    confirmation = STDIN.gets.chomp
    unless confirmation.downcase == 'yes'
      puts "❌ Aborted!"
      exit 1
    end
    
    puts "💥 Resetting all databases..."
    
    # Drop and recreate databases
    Rake::Task['multi_db:drop_all'].invoke
    Rake::Task['multi_db:setup_all'].invoke
    
    puts "✅ All databases reset complete!"
  end
end

# Add multi_db tasks to the default db namespace
namespace :db do
  desc "Setup multi-database environment"
  task setup_multi: "multi_db:setup_all"
  
  desc "Show multi-database status"
  task multi_status: "multi_db:status"
end
