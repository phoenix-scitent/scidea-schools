Rails.application.routes.draw do
  resources :schools, :only => [:index, :create, :update, :edit]

  namespace 'admin' do
    resources :schools do
      member do
        get "migration/new", :action => :new_migration
        get "migration/:target_school_id/confirm", :action => :confirm_migration, :as => 'confirm_migration'
        post "migration/:target_school_id", 
             :action => :create_migration, 
             :constraints => { :target_school_id => /\d+/ }, 
             :as => 'create_migration'
      end
    end
  end

  # non-production routes
  unless Rails.env.production?
    namespace 'test' do
      get 'scidea_schools_qunit_tests', :to => 'scidea_schools_qunit_tests#index'
      get 'scidea_schools_qunit_tests/*test_names', :to => 'scidea_schools_qunit_tests#index'    
    end
  end

end
