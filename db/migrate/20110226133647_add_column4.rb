class AddColumn4 < ActiveRecord::Migration
  def self.up
    add_column :users, :level, :string
  end

  def self.down
  end
end
