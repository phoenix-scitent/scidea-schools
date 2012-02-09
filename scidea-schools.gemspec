$:.push File.expand_path("../lib", __FILE__)

require "scidea/schools/version"

Gem::Specification.new do |s|
  s.name        = 'scidea-schools'
  s.version     = Scidea::Schools::VERSION
  s.date        = '2012-01-16'

  s.summary     = "Schools extension for the Scitent Scidea platform"
  s.description = "Schools augments user's profiles with an associated school, along with interfaces for adding new schools at runtime. Administrators can manage schools and modify learner's schools."

  s.authors     = ["Phoenix Team"]
  s.email       = ['phoenix@scitent.com']

  s.files       = Dir["{lib}/**/*.rb"]
 
  s.homepage    = 'https://github.com/phoenix-scitent/scidea-schools'

  s.add_dependency 'scidea', '~> 0.0.1'
  s.add_dependency 'rails', ['>= 3.1.3', '< 3.3']
  s.add_dependency 'bartt-ssl_requirement', '1.3.1'
  s.add_dependency 'cancan'
  s.add_dependency 'will_paginate', '~> 3.0'

  s.add_development_dependency 'sqlite3-ruby'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'shoulda', '>= 3.0.0.beta'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'compass'
end
