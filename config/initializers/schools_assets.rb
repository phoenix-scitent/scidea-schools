Phoenix::Application.configure do
  config.assets.precompile += ['scidea/admin/pages/schools/user_migrate.css',
                               'scidea/pages/schools/user_profile.css']
end

