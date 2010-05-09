class AddColumn2 < ActiveRecord::Migration
  def self.up
    add_column :memos, :category, :string
  end

  def self.down
  end
end
