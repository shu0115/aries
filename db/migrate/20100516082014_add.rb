class Add < ActiveRecord::Migration
  def self.up
    add_column :memos, :user_id, :string
  end

  def self.down
  end
end
