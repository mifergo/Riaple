class AddSprintToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :sprint_id, :integer
  end

  def self.down
    remove_column :features, :sprint_id
  end
end
