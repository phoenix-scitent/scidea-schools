module SeedUserRoles
  def self.seed
    Role.public || Factory( :role_public )
    Role.learner || Factory( :role_learner )
    Role.user_admin || Factory(:role_user_admin)
    Role.course_admin || Factory(:role_course_admin)
    Role.product_admin || Factory(:role_product_admin)
    Role.tech_support || Factory(:role_tech_support)
    Role.scitent_admin || Factory(:role_scitent_admin)
  end

  def self.clean
    Role.destroy_all
  end
end

