
# purge database before every scenario
Before do |scenario|
  Mongoid.purge!
end