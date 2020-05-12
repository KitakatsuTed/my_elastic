# Be sure to restart your server when you modify this file.
redis_uri = URI(ENV['REDIS_URL'])
# http://higelog.brassworks.jp/?p=2307
Rails.application.config.session_store :redis_store, expire_after: 60.days, :servers => {
  host: redis_uri.host,
  port: redis_uri.port,
  password: redis_uri.password,
  namespace: "es_practice:app"
}, expires_in: 60.days
