class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

  throttle('api/ip', limit: 30, period: 60) do |req|
    req.ip
  end
end