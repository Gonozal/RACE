source 'http://rubygems.org'

gem 'rails', "3.2.6"

# Database Gems
gem 'sqlite3'
gem 'mysql'

# Composite Pirmary Keys on a model level
gem "composite_primary_keys", ">= 5.0.0.rc1"

# Jquery JS library
gem 'jquery-rails'
gem 'wicked'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass'
end

# View Layer
gem 'draper'
gem 'simple_form'
gem 'formtastic'
gem 'slim'
gem 'will_paginate', '~> 3.0'

# Performance Booster Gems
gem 'activerecord-import'

# Athorisaion and Authentication
gem 'declarative_authorization'
gem 'bcrypt-ruby'
gem 'devise'

# Custom RACE specific gems
gem 'nokogiri'

# Scheduler
gem 'whenever'

# Background Jobs
gem 'resque', :require => 'resque/server' #, git: 'git://github.com/defunkt/resque.git'

# Images
gem 'rmagick'

# Ancestry for recursive assets in containers
gem 'ancestry'

group :strange_dependencies do
  gem 'ruby_parser'
  gem 'json'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :development do
  gem 'foreman'
end

group :test, :development do
  # Pretty printed test output
  gem 'turn', :require => false
  #gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem "guard-rspec"
  gem "factory_girl_rails", :require => false
  gem 'vcr'
  gem 'fakeweb'
  gem 'capybara-mechanize'
end
