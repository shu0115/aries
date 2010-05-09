class AddColumn < ActiveRecord::Migration
  def self.up
    add_column :memos, :mode, :string
  end

  def self.down
  end
end
