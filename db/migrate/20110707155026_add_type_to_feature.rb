class AddTypeToFeature < ActiveRecord::Migration
  def self.up
    add_column "features", "kind", :string
  end

  def self.down
    remove_column "features", "kind"
  end
end
