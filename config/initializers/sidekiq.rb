require "sidekiq"
require "yaml"

begin
  require "sidekiq/cron/job"
rescue LoadError
  Rails.logger.warn("⚠️ sidekiq-cron not installed; skipping cron jobs")
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }

  schedule_file = Rails.root.join("config", "sidekiq.yml")
  if File.exist?(schedule_file) && defined?(Sidekiq::Cron::Job)
    schedule = YAML.load_file(schedule_file)
    Sidekiq::Cron::Job.load_from_hash(schedule["schedule"]) if schedule&.dig("schedule")
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }
end
