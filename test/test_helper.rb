ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path(File.dirname(__FILE__) + "/blueprints")

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  # Add more helper methods to be used by all tests here...
  #self.use_transactional_fixtures = true
  #self.use_instantiated_fixtures  = false
  setup { Sham.reset }

  def http_auth(user, pass)
    @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64.encode64(user + ':' + pass)
  end
end

require 'test/unit'
require 'mocha'

