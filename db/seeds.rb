admin_nav_secondary = Menu.find_or_create_by_name(:name => "Admin Navigation: Secondary")

# Helper method for assigning roles to menu elements and subelements
def roles_to_list(role_array)
  role_array.map{ |r| r.id.to_s }.join(',')
end

menu_element = MenuElement.find_or_create_by_url(
              :menu => admin_nav_secondary,
              :url => "/admin/schools",
              :view_role_list => roles_to_list([Role.course_admin, Role.scitent_admin]), 
              :edit_role_list => roles_to_list([Role.product_admin, Role.scitent_admin]), 
              :order_sequence => 102)

MenuElementTranslation.find_or_create_by_display_name(
              :display_name => "Educational Institutions", 
              :locale => 'en',
              :menu_element => menu_element.id,
              :menu_element_type => 'MenuElement')

MenuElementTranslation.find_or_create_by_display_name(
              :display_name => "Etablissements d'Enseignement", 
              :locale => 'fr',
              :menu_element => menu_element.id,
              :menu_element_type => 'MenuElement')


