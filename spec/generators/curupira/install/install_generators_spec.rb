require 'rails_helper'
require "generators/curupira/install/install_generator"

describe Curupira::Generators::InstallGenerator, :generator do

  before :all do
    Object.send(:remove_const, :UserGroup) if defined?(UserGroup)
  end

  before do
    provide_existing_routes_file
  end

  describe "sorccery initializer" do
    it "is copied to the application" do
      run_generator
      initializer = file("config/initializers/sorcery.rb")

      expect(initializer).to exist
      expect(initializer).to have_correct_syntax
      expect(initializer).to contain("Rails.application.config.sorcery.configure do |config|")
    end
  end

  describe "user_group" do
    context "no existing user group class" do
      it "generates user group" do
        run_generator

        user_group = file("app/models/user_group.rb")

        expect(user_group).to exist
      end
    end

    it "adds validations" do
      run_generator

      user_group = file("app/models/user_group.rb")

      expect(user_group).to contain("validates_presence_of :name")
    end
  end

  describe "role_model" do
    context "no existing role class" do
      it "generates role" do
        run_generator
        role_class = file("app/models/role.rb")

        expect(role_class).to exist
        expect(role_class).to have_correct_syntax
      end

      it "adds validations" do
        run_generator

        role_class = file("app/models/role.rb")

        expect(role_class).to contain("validates_presence_of :name")
      end
    end

    context "role class already exists" do
      it "includes validations" do
        run_generator
        user_class = file("app/models/role.rb")

        expect(user_class).to exist
        expect(user_class).to have_correct_syntax
        expect(user_class).to contain("validates_presence_of :name")
      end
    end
  end

  describe "user_model" do
    context "no existing user class" do
      it "creates a user class Curupira configurations" do
        run_generator
        user_class = file("app/models/user.rb")

        expect(user_class).to exist
        expect(user_class).to have_correct_syntax
        expect(user_class).to contain("authenticates_with_sorcery!")
        expect(user_class).to contain("validates_presence_of :email")
      end
    end

    context "user class already exists" do
      it "includes Curupira configurations" do
        provide_existing_user_class

        run_generator
        user_class = file("app/models/user.rb")

        expect(user_class).to exist
        expect(user_class).to have_correct_syntax
        expect(user_class).to contain("authenticates_with_sorcery!")
        expect(user_class).to contain("validates_presence_of :email")
      end
    end
  end

  describe "user migration" do
    context "users table does not exist" do
      it "creates a migration to create the users table" do
        allow(ActiveRecord::Base.connection).to receive(:table_exists?).
          with(:users).
          and_return(false)

        run_generator
        migration = migration_file("db/migrate/sorcery_core.rb")

        expect(migration).to exist
        expect(migration).to have_correct_syntax
        expect(migration).to contain("create_table :users")
      end
    end

    context "existing users table with all curupira columns and indexes" do
      it "does not create a migration" do
        run_generator
        create_migration = migration_file("db/migrate/sorcery_core.rb")
        add_migration = migration_file("db/migrate/add_curupira_to_users.rb")

        expect(create_migration).not_to exist
        expect(add_migration).not_to exist
      end
    end

    context "existing users table missing some columns and indexes" do
      it "create a migration to add missing columns and indexes" do
        Struct.new("Named", :name)
        existing_columns = [Struct::Named.new("username")]
        existing_indexes = [Struct::Named.new("index_users_on_username")]

        allow(ActiveRecord::Base.connection).to receive(:columns).
          with(:users).
          and_return(existing_columns)

        allow(ActiveRecord::Base.connection).to receive(:indexes).
          with(:users).
          and_return(existing_indexes)

        run_generator
        migration = migration_file("db/migrate/add_curupira_to_users.rb")

        expect(migration).to exist
        expect(migration).to have_correct_syntax
        expect(migration).to contain("change_table :users")
        expect(migration).to contain("t.string :email")
        expect(migration).to contain("add_index :users, :reset_password_token")
        expect(migration).not_to contain("t.string :username")
        expect(migration).not_to contain("add_index :users, :index_users_on_username")
      end
    end
  end
end