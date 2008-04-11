class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.column :article_id, :integer
      t.column :url, :string
    end
  end

  def self.down
    drop_table :links
  end
end
