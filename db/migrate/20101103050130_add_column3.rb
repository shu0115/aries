class AddColumn3 < ActiveRecord::Migration
  def self.up
    add_column :memos, :sub_category, :string
  end

  def self.down
  end
end
