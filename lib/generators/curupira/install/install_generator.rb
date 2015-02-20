require 'rails/generators/active_record'

module Curupira
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def create_user_model
        if File.exist? "app/models/user.rb"
          # inject_into_file(
          #   "app/models/user.rb",
          #   "include Clearance::User\n\n",
          #   after: "class User < ActiveRecord::Base\n"
          # )
        else
          copy_file 'user.rb', 'app/models/user.rb'
        end
      end

      def create_user_migration
        # if users_table_exists?
        #   create_add_columns_migration
        # else
        #   copy_migration 'create_users.rb'
        # end
        copy_migration 'create_users.rb'
      end

      private

      def users_table_exists?
        ActiveRecord::Base.connection.table_exists?(:users)
      end

      def copy_migration(migration_name, config = {})
        # unless migration_exists?(migration_name)
        #   migration_template(
        #     "db/migrate/#{migration_name}",
        #     "db/migrate/#{migration_name}",
        #     config
        #   )
        # end
        migration_template(
          "db/migrate/#{migration_name}",
          "db/migrate/#{migration_name}"
        )
      end
      
      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end
    end
  end
end