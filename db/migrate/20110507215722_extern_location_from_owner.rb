class ExternLocationFromOwner < ActiveRecord::Migration
  def self.up
    remove_column :owners, :location
    add_column :owners, :location_id, :integer
  end

  def self.down
    remove_column :owners, :location_id
    add_column :owners, :location, :string
  end
end
