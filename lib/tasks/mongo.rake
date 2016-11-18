# collection of tasks for working with MongoDB databases
# known providers should have env variables set:
#   MONGOHQ_URI
#   MONGOLAB_URI

require "uri"
require "pathname"

BACKUP_PATH = "db/backups"

namespace :mongo do
  desc "checks mongodb tools are installed"
  task :mongo_tools do
    ["mongo", "mongodump", "mongorestore"].each do |tool|
      abort("Did not find #{tool}. Is it installed? Is it in your path?") if `which #{tool}`.blank?
    end
  end

  desc "backup a database to db/backups"
  task :backup, [:provider] => :mongo_tools do |t, args|
    abort("Required param :provider") unless args[:provider]

    uri = resolve_mongo_provider(args[:provider])
    `mongodump -v -p #{uri.password} -h #{uri.host}:#{uri.port} -u #{uri.user} -d #{uri.path.sub("/", "")} -o #{backup_dest(uri)}`
  end
end

def resolve_mongo_provider(arg)
  provider = arg.upcase
  return URI(ENV[provider]) if provider.end_with?("_URI") && ENV[provider]

  provider = "#{provider}_URI"
  return URI(ENV[provider]) if ENV[provider]

  abort("Could not find a mongodb provider for #{arg}")
end

def backup_dest(uri)
  Pathname
    .new(BACKUP_PATH)
    .join("#{uri.user}@#{uri.host}")
    .to_s
end
