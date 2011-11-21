class AddWeightToFeature < ActiveRecord::Migration
  def self.up
    add_column "features", "weight", :integer, :default => 1
  end

  def self.down
    remove_column "features", "weight"
  end
end
