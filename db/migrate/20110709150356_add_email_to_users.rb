class AddEmailToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string
    add_column :users, :surname, :string
    add_column :users, :login, :string
  end

  def self.down
    remove_column :users, :email
    remove_column :users, :surname
    remove_column :users, :login
  end
end
