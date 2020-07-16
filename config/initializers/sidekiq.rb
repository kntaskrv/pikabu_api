sidekiq_config = { url: 'redis://redis:6379/0'}

schedule_file = Rails.root.join('config', 'schedule.yml')

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
  config.logger.level = Logger::INFO
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end




