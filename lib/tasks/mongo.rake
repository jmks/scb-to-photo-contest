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

  desc "opens the mongo shell to the given mongodb provider"
  task :shell, [:provider] => [:mongo_tools] do |t, args|
    abort("Required param :provider") unless args[:provider]

    provider_uri = resolve_mongo_provider(args[:provider])
    exec("mongo #{provider_uri.to_s}")
  end

  desc "backup a database to #{BACKUP_PATH}"
  task :backup, [:provider] => :mongo_tools do |t, args|
    abort("Required param :provider") unless args[:provider]

    uri = resolve_mongo_provider(args[:provider])
    `mongodump -v -p #{uri.password} -h #{uri.host}:#{uri.port} -u #{uri.user} -d #{uri.path.sub("/", "")} -o #{backup_dest(uri)}`
  end

  desc "restores a backup from the given source to the given destination"
  task :restore, [:source, :destination] do |t, args|
    abort("Required param :source") unless args[:source]
    abort("Required param :destination") unless args[:destination]

    src  = resolve_mongo_provider(args[:source])
    dest = resolve_mongo_provider(args[:destination])

    # generalized this command:
    # mongorestore -v -u #{dest.user} -p #{dest.password} -h #{dest.host}:#{dest.port} -d #{dest.path.sub("/", "")} #{backup_src(src)}
    # ignores user and password options if not present in destination uri (e.g. localhost)
    cmd = [
      "mongorestore",
      "-v",
      "-h #{dest.host}:#{dest.port}",
      "-d #{dest.path.sub("/", "")}"
    ]
    cmd << "-u #{dest.user}" if dest.user
    cmd << "-p #{dest.password}" if dest.password
    cmd << backup_src(src)

    `#{cmd.join(' ')}`
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
end

def backup_src(uri)
  backup_dest(uri).join(uri.path.sub("/", ""))
end
