source 'http://rubygems.org'

gem 'rails', '4.1.6'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-migrate-rails'
gem 'j_growl_rails'
gem 'blockuijs-rails',  :git => 'git://github.com/rusanu/blockuijs-rails.git'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

gem "delayed_job"
gem 'delayed_job_active_record'

gem 'daemons'
gem 'cairo'
gem 'pango'
gem 'authlogic'
gem "guid"
gem 'dynamic_form'
gem 'nuntium_api'

gem 'bootstrap-sass'
gem 'haml-rails'
gem 'instedd-bootstrap', git: "https://bitbucket.org/instedd/instedd-bootstrap.git", branch: 'master'

# Use unicorn as the web server
# gem 'unicorn'

group :development do
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'rvm-capistrano'
end

gem 'foreman'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'pry'
  gem 'pry-debugger'
end

group :test do
  gem "test-unit"
  gem "mocha", require: false
  gem 'machinist', '1.0.6'
  gem 'faker'
end

