# elastic searchクライアントのセット
Elasticsearch::Model.client = Elasticsearch::Client.new(
  log: false,
  host: ENV["ES_HOST"] || '127.0.0.1',
  port: ENV["ES_PORT"] || 9300,
  user: ENV["ES_USER"] || nil,
  password: ENV["ES_PASSWORD"] || nil,
  request_timeout: ENV["ELASTICSEARCH_TIMEOUT"].to_i || 20
)
