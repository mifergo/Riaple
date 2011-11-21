class CreateSprints < ActiveRecord::Migration
  def self.up
    create_table :sprints do |t|
      t.string :name
      t.text :objective
      t.date :start
      t.date :end

      t.timestamps
    end
  end

  def self.down
    drop_table :sprints
  end
end
