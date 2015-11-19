source 'https://rubygems.org'
ruby '1.9.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'backstretch-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Use MongoDB as database
gem 'mongoid', '~> 4.0.0.beta1'
gem 'bson'
gem 'bson_ext'

gem 'aasm'

gem 'thin'

gem 'rails_12factor', group: :production

# Use devise for authentication
gem 'devise'

# Use HAML templating
gem 'haml'

# Use Twitter Bootstrap
gem 'bootstrap-sass', '~> 3.0.3.0'
gem 'font-awesome-rails'
gem 'bootstrap-slider-rails'

gem 'modernizr-rails'

# for uploading
gem 's3_direct_upload'

# for background processing
gem 'resque'
gem 'redis'

# AWS
gem 'aws-sdk', '~> 1.0'

# generating thumbnails
gem 'rmagick'

# typeahead picker
gem 'select2-rails'

# heroku startup
gem 'foreman'

# recapcha
gem 'recaptcha', require: 'recaptcha/rails'

# monitoring
gem 'newrelic_rpm'

# Use RSpec and Cucumber for TDD
group :development, :test do
  gem 'capybara'
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'quiet_assets'
  gem 'spring-commands-rspec'
end

# rails panel
group :development do
  gem 'meta_request'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'shoulda-matchers'
  gem 'fakeweb'
  gem 'timecop'
end
