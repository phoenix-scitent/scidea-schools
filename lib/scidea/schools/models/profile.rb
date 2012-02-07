module Scidea
  module Schools
    module Models
      module Profile
        extend ActiveSupport::Concern

        included do
          belongs_to :school
          validate :school_present_if_educator_audience

        end

        module ClassMethods
        end
       
        module InstanceMethods
          def audience_is_educator?
            audience && audience.name.downcase == 'educator'
          end

          def school_present_if_educator_audience
            errors.add(:school, "Educational institution required if you are an educator") if audience_is_educator? && school.nil?
          end
        end      

      end # profile
    end # models
  end
end
