# If your client is single-threaded, we just need a single connection in our Redis connection pool
if Rails.env.development?
  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://redis:6379/0', size: 5 }
  end

  # Sidekiq server is multi-threaded so our Redis connection pool size defaults to concurrency (-c)
  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://redis:6379/0' }
  end
end
