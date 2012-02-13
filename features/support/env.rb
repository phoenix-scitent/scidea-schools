ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../../config/environment",  __FILE__)

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'rspec/expectations'
require 'cucumber/rails'
require 'email_spec'
require 'email_spec/cucumber'

# Remove this line if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
DatabaseCleaner.strategy = :transaction

Cucumber::Rails::World.use_transactional_fixtures = false

Before do
  page.driver.options[:resynchronize] = true
end

# load local factories which will be added to the factories from scidea.
Dir.glob(File.join(File.dirname(__FILE__), '../../spec/factories/*.rb')).each {|f| require f }
