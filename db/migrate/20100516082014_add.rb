class Add < ActiveRecord::Migration
  def self.up
#    add_column :memos, :user_id, :string
    add_column :memos, :user_id, :integer
  end

  def self.down
  end
end
