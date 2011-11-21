class RemoveSprintFromFeature < ActiveRecord::Migration
  def self.up
    remove_column('features', 'sprint')
  end

  def self.down
    add_column('features', 'sprint', :string)
  end
end
