module Scidea
  module Schools
    class Engine < ::Rails::Engine

      initializer "scidea.schools.register_view_callbacks" do

        Scidea::Plugins::Plugin.on(:admin_user_form_after_profile)   { conditional_render('admin/users/school_edit') }
      
        Scidea::Plugins::Plugin.on(:registration_new_after_profile)  { conditional_render('users/school_edit') }        
        Scidea::Plugins::Plugin.on(:user_profile_form_after_profile)  { conditional_render('users/school_edit') }

        Scidea::Plugins::Plugin.on(:admin_user_profile_after_profile) { 'admin/users/profile_show_school' }

        Scidea::Plugins::Plugin.on(:user_profile_page_js) { 'backbone_apps/school_selector' }
      end

      config.to_prepare do
        load 'scidea/schools/models/mixins.rb'
      end

      private
      def conditional_render(partial)
        School.render_form? ? partial : nil
      end

    end # class Engine
  end
end
