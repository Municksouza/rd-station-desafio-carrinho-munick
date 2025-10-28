require "sidekiq"
begin
  require "sidekiq/cron/job"
rescue LoadError
  Rails.logger.warn("sidekiq-cron não instalado; ignorando cron")
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }
  path = Rails.root.join("config/sidekiq.yml")
  if defined?(Sidekiq::Cron::Job) && File.exist?(path)
    raw = YAML.load_file(path)
    Sidekiq::Cron::Job.load_from_hash raw["schedule"] if raw.is_a?(Hash) && raw["schedule"].is_a?(Hash)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }
end
