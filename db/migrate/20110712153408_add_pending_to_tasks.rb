class AddPendingToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :pending, :integer
  end

  def self.down
    remove_column :tasks, :pending
  end
end
