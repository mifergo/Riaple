class DeleteOwnerFromFeatures < ActiveRecord::Migration
  def self.up
    remove_column :features, :owner
  end

  def self.down
    add_column :features, "owner", :string
  end
end
