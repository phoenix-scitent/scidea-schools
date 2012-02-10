require 'scidea/plugins/update_migration_generator'

module Scidea
  module Schools
    class MigrationsGenerator < Scidea::Plugins::UpdateMigrationGenerator
      MigrationsGenerator.source_root(File.expand_path('templates', File.dirname(__FILE__) ) )

      def plugin_migrations_path
        MigrationsGenerator.source_root
      end

    end
  end
end
