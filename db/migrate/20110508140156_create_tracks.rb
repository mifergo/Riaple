class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.integer :task_id
      t.date :date
      t.integer :pending

      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
