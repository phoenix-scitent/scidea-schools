module Scidea
  module Schools
    module Models
      module Ability
        extend ActiveSupport::Concern

        module InstanceMethods
          def initialize_namespace_admin(user)
            super

            can(:manage, [School]) if user.has_role?(Role.course_admin)
          end

          def initialize_namespace_none(user)
            super

            # required for registration form              
            can([:index, :create, :update], School) 

            # required for profile form
            can([:index, :create, :update], School) if user.has_role? Role.learner
          end
        end      

      end # ability
    end # models
  end
end
