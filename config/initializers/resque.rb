begin
  uri = URI.parse(ENV["REDISTOGO_URL"])

  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
rescue URI::InvalidURIError
  abort("Expected env var REDISTOGO_URL to be a URI. Got '#{ENV["REDISTOGO_URL"]}'")
rescue => e
  abort("Error setting up Resque: #{e.message}")
end
