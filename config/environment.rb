# Load schools Gemfile and get the path to the local core application
# (from standard rails config/boot.rb)
gemfile = File.expand_path('../../Gemfile', __FILE__)
begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)

# get only the paths constants; let scidea core load all gems
require 'scidea/paths.rb'

# Load and initialize the Scidea core application
require File.expand_path('../config/environment', Scidea::APP_PATH)
