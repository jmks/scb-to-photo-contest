namespace :dev do
  desc "task to set environment"
  task :set_development_env do
    Rails.env = "development"
  end

  desc "added 10 additional photos to test database"
  task add_photos: [:set_development_env, :environment] do
    FactoryGirl.create_list :photo, 10
  end

  desc "loads data for testing into database"
  task load_test: [:set_development_env, :environment] do
    require Rails.root.join("db", "test.rb")
  end
end
