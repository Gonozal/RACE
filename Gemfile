source 'http://rubygems.org'

gem 'rails', "~> 3.1.3"


# Bundle ed ge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Asset template engines
gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'
gem 'slim'

gem 'jquery-rails'

# Custom RACE specific gems
gem 'nokogiri'
gem 'simple_form'
gem 'declarative_authorization'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'resque', :require => 'resque/server' #, git: 'git://github.com/defunkt/resque.git'
gem 'devil'

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
  # gem 'nifty-generators'
end

group :darwin do
  gem 'guard'
  gem 'growl'
  gem 'guard-minitest'
  gem 'guard-cucumber'
  gem 'guard-spork'
end

group :test, :development do
  # Pretty printed test output
  gem 'turn', :require => false
  #gem 'capybara', '>= 1.0.0'
  #gem 'pickle'
  #gem 'cucumber-rails'
  gem 'database_cleaner'
  #gem 'rspec'
  #gem 'spork', '>= 0.9.0.rc'
  #gem 'factory_girl_rails'
  #gem 'capybara-webkit',  '>= 1.0.0.beta', :platform => :ruby
end