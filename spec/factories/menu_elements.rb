FactoryGirl.define do
  factory :menu_element_admin_with_url, :parent => :menu_element_with_url do
    view_roles { [Role.product_admin, Role.course_admin, Role.user_admin] }
  end
end
