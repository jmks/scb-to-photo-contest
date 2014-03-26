uri = URI.parse(ENV["REDISTOGO_URL"])
if Rails.env.production?
    Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
end