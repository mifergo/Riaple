class AddEffortToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :effort, :integer
  end

  def self.down
    remove_column :tasks, :effort
  end
end
