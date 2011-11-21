class ChangeColumnsToFeatures < ActiveRecord::Migration
  def self.up
    rename_column(:sprints, :end, "finish")
    rename_column(:features, :end, "finish")
  end

  def self.down
    rename_column(:sprints, "finish", "end")
    rename_column(:features, "finish", "end")
  end
end
