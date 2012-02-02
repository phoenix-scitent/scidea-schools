# http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/

source :rubygems

gemspec

# gem 'scidea', 'scidea', '~> 0.0.1', :path => '/home/mschaefer/src/phx'

gem 'rails', '= 3.1.3'

gem 'bartt-ssl_requirement', '1.3.1', :require => 'ssl_requirement'
gem 'cancan'
gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'will_paginate', '~> 3.0'

group :development do
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'shoulda', '>= 3.0.0.beta'
end
