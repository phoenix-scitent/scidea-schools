require_relative 'profile'
require_relative 'ability'

Profile # call first becuase it needs to be autoloaded with activerecord methods
class Profile
  include Scidea::Schools::Models::Profile
end

Ability # call first to autoload base class
class Ability
  include Scidea::Schools::Models::Ability
end
