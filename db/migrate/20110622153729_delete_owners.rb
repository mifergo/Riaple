class DeleteOwners < ActiveRecord::Migration
  def self.up
    drop_table :owners
  end

  def self.down
    create_table "owners" do |t|
      t.string   "name"
      t.integer  "location_id"
    end
  end
end
