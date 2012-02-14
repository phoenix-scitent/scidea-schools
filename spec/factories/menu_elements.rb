Factory.define :menu_element_admin_with_url, :parent => :menu_element_with_url do |f|
  f.view_roles { |m| [Role.product_admin, Role.course_admin, Role.user_admin] }
end
