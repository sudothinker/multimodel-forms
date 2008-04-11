class AddUserIdToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :user_id, :integer
    add_column :articles, :user_id, :integer
  end

  def self.down
    remove_column :links, :user_id
    remove_column :articles, :user_id
  end
end
