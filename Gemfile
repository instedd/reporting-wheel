source 'http://rubygems.org'

gem 'rails', '3.0.20'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

gem 'test-unit', :require => 'test/unit'
gem "mocha", :require => 'mocha'
gem "delayed_job",  :git => 'git://github.com/collectiveidea/delayed_job.git'

gem 'daemons'
gem 'cairo', '= 1.15.3'
gem 'pango', '= 2.2.5'
gem 'authlogic'
gem "guid"
gem 'dynamic_form'
gem 'nuntium_api'

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
	gem 'machinist'
	gem 'faker'
  gem 'pry'
  gem 'pry-debugger'
end
