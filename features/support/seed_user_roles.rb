module SeedUserRoles
  def self.seed
    Role.public || FactoryGirl.create( :role_public )
    Role.learner || FactoryGirl.create( :role_learner )
    Role.user_admin || FactoryGirl.create(:role_user_admin)
    Role.course_admin || FactoryGirl.create(:role_course_admin)
    Role.product_admin || FactoryGirl.create(:role_product_admin)
    Role.tech_support || FactoryGirl.create(:role_tech_support)
    Role.scitent_admin || FactoryGirl.create(:role_scitent_admin)
  end

  def self.clean
    Role.destroy_all
  end
end

