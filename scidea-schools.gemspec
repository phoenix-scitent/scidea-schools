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
end
