require 'scidea/schools'

ENV["RAILS_ENV"] ||= 'test'

require 'rspec/rails'
require 'rspec_tag_matchers'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
 
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.extend ControllerMacros, :type => :controller

end
