class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.string :name
      t.string :priority
      t.string :project
      t.string :sprint
      t.string :state
      t.string :owner
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
