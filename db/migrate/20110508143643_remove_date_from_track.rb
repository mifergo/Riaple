class RemoveDateFromTrack < ActiveRecord::Migration
  def self.up
    remove_column :tracks, :date
    add_column :tracks, :sprint_id, :integer
    add_column :tracks, :day, :integer
  end

  def self.down
    add_column :tracks, :date, :date
    remove_column :tracks, :sprint_id
    remove_column :tracks, :day
  end
end
