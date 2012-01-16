class School < ActiveRecord::Base

  has_many :profiles

  # approved field deliberately excluded so public-facing users cannot maliciously approve bad schools
  attr_accessible :address_1, :address_2, :city, :name, :state, :zipcode, :phone

  validates_presence_of :address_1
  validates_presence_of :city
  validates_presence_of :name
  validates_presence_of :state
  validates_presence_of :zipcode
  validates_presence_of :phone

  validate :zipcode_formatting
  validate :phone_formatting

  ZIPCODE_PATTERN = /^[\d]{5}$/

  # Class methods

  def self.render_form?
    count > 0 and Audience.count > 0
  end
  
  # handles zipcode searches from learner-side forms; will filter out schools
  # that are not approved by the admin UNLESS that school is passed via the
  # user_created_school parameter, which allows the unapproved school created
  # by the current user to be returned as a part of the search query
  def self.learner_form_search(zipcode, user_created_school = nil)
    return [] unless zipcode && zipcode.match(ZIPCODE_PATTERN)

    schools = where('zipcode = ?', zipcode).where('approved = true').order('name asc').all
    
    # the school the user created should be included in the returned list only if these conditions are met
    if user_created_school && user_created_school.zipcode == zipcode && !user_created_school.approved
      schools << user_created_school
      schools.sort! { |a,b| a.name <=> b.name } # sort the user_created_school into the right location
    end

    schools
  end

  def self.search(name_or_zipcode)
    name_or_zipcode ? where('name LIKE ? OR zipcode LIKE ?', "%#{name_or_zipcode}%", "%#{name_or_zipcode}%") : scoped
  end

  def self.without_school(school)
    where('schools.id != ?', school.id)
  end
  
  # Instance methods

  # moves all users associated with this school to school parameter, returns
  # an array of all users migrated from this school to the school parameter
  def migrate_users_to(school)
    raise ArgumentException unless school

    profiles.map do |profile| 
      profile.school = school
      profile.save
      profile.user # returned through method call via an array (from map)
    end
  end

  def phone=(val)
    write_attribute :phone, val.nil? ? '' : val.split(//).select{|char| char.match(/^\d$/) }.join.gsub(/^1/, '')
  end

  def phone
    p = read_attribute :phone
    (p.nil? || p.size < 10) ? p : "(#{p[0,3]}) #{p[3,3]}-#{p[6,4]}#{p.size > 10 ? 'x' + p[10..-1]: ''}"
  end

  def to_client_model_json
    to_json :except => [:created_at, :updated_at]
  end

  def user_count
    profiles.count
  end

  private

  def phone_formatting
    errors[:phone] << "must be at least 10 digits long" unless self.phone.nil? || self.phone.empty? || self.phone.size >= 10
  end

  def zipcode_formatting
    errors.add(:zipcode, "must be five numbers") unless zipcode && zipcode.match(ZIPCODE_PATTERN)
  end

end
