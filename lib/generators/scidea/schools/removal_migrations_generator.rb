require 'scidea/plugins/remove_migration_generator'

module Scidea
  module Schools
    class RemovalMigrationsGenerator < Scidea::Plugins::RemoveMigrationGenerator
      RemovalMigrationsGenerator.source_root(File.expand_path('templates/removal', File.dirname(__FILE__) ) )

      def plugin_migrations_path
        RemovalMigrationsGenerator.source_root
      end

    end
  end
end
