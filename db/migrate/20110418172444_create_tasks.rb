class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.date :start
      t.string :status
      t.date :finish
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
