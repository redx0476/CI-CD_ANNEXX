# Multi-database configuration for ANNEXX
# This initializer sets up connections to cache, queue, and cable databases

Rails.application.configure do
  # Configure solid_queue connections
  if defined?(SolidQueue) && config.respond_to?(:solid_queue)
    config.solid_queue.connects_to = { database: { writing: :queue } }
  end
  
  # Solid_cache and solid_cable connections are handled automatically by Rails
  # when the cache_store and cable adapter are configured in environment files
end

# Database connection management
module DatabaseConnections
  extend self
  
  def connect_to_cache_db
    ActiveRecord::Base.connects_to database: { writing: :cache }
  end
  
  def connect_to_queue_db  
    ActiveRecord::Base.connects_to database: { writing: :queue }
  end
  
  def connect_to_cable_db
    ActiveRecord::Base.connects_to database: { writing: :cable }
  end
  
  def connect_to_primary_db
    ActiveRecord::Base.connects_to database: { writing: :primary }
  end
  
  def database_status
    {
      primary: connection_status(:primary),
      cache: connection_status(:cache), 
      queue: connection_status(:queue),
      cable: connection_status(:cable)
    }
  end
  
  private
  
  def connection_status(db_name)
    ActiveRecord::Base.connected_to(database: { writing: db_name }) do
      ActiveRecord::Base.connection.active?
    end
  rescue => e
    "Error: #{e.message}"
  end
end
