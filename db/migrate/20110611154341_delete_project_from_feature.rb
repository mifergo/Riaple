class DeleteProjectFromFeature < ActiveRecord::Migration
  def self.up
    remove_column :features, :project
  end

  def self.down
    add_column :features, :project, :string
  end
end
