redis_conn = proc {
  Redis.new(url: Settings.redis.connection_url)
}

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, &redis_conn)
end
Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 27, &redis_conn)
end

$redis = redis_conn.call