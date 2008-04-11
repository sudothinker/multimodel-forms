class AddingDateToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :published_on, :datetime
  end

  def self.down
    remove_column :links, :published_on
  end
end
