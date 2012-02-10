namespace :db do
  task :seed do
    Scidea::Schools::Engine.load_seed
  end
end
