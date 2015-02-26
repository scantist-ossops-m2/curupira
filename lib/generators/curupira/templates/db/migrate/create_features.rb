class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :description
      t.string :path_info
      t.string :request_method
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
