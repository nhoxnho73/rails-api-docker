redis_url =
  if Rails.env.development?
    'redis://redis:6379/0'
  end

Redis.current = ConnectionPool::Wrapper.new(size: 10, timeout: 5) do
  Redis.new(url: redis_url)
end