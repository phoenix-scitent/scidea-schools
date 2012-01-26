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

end
