Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }

  # 非同期処理でエラーが発生したときにここで開発者に通知する
  # config.error_handlers << Proc.new do |exception, ctx_hash|
  #   return if exception.nil?
  #   logger.info "Async Processing with exception: #{exception.message}"
  #   logger.warn(exception.backtrace.join("\n"))
  #
  #   Rollbar.error(exception, ctx_hash)
  # end
end

# if Rails.env.production? || Rails.env.staging?
#   schedule_file = "config/schedule.yml"
#
#   if File.exist?(schedule_file) && Sidekiq.server?
#     Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
#   end
# end
