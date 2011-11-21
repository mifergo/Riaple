class AddUserIdToTask < ActiveRecord::Migration
  def self.up
    remove_column :tasks, :owner_id
    add_column :tasks, :user_id, :integer
  end

  def self.down
    remove_column :tasks, :user_id
    add_column :tasks, :owner_id, :integer
  end

end
