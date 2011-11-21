class AddDatesToFeature < ActiveRecord::Migration
  def self.up
    add_column "features", "start", :date
    add_column "features", "end", :date
  end

  def self.down
    remove_column "features", "start", "end"
  end
end
