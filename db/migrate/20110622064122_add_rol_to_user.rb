class AddRolToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :rol, :string
    add_column :users, :location_id, :integer
  end

  def self.down
    remove_column :users, :rol
    remove_column :users, :location_id
  end
end
