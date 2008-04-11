class LinkPositions < ActiveRecord::Migration
  def self.up
    add_column :links, :position, :integer
  end

  def self.down
    remove_column :links, :position
  end
end
