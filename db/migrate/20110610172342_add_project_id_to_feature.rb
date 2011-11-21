class AddProjectIdToFeature < ActiveRecord::Migration
  def self.up
    add_column :features, :project_id, :integer
  end

  def self.down
    remove_column :features, :project_id
  end
end