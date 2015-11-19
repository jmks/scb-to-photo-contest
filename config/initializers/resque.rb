begin
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
rescue URI::InvalidURIError
  Rails.logger.error "The env var REDISTOGO_URL is invalid"
end
