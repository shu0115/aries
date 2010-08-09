class ChangeColumn02 < ActiveRecord::Migration
  def self.up
    change_column :memos, :user_id, :integer
  end

  def self.down
  end
end
