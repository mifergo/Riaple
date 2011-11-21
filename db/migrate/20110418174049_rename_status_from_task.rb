class RenameStatusFromTask < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :status, :state
  end

  def self.down
    rename_column :tasks, :state, :status
  end
end
