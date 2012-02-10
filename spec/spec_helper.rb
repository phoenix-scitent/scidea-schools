ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'scidea-schools'

require 'rspec/rails'
require 'rspec_tag_matchers'
require 'cancan/matchers'
require 'paperclip/matchers'

require File.expand_path("../../features/support/seed_user_roles.rb", __FILE__)

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
 
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    ::SeedUserRoles.seed
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    ::SeedUserRoles.clean
  end
end

# load local factories which will be added to the factories from scidea.
Rails.configuration.after_initialize do
  FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
  FactoryGirl.find_definitions
end
