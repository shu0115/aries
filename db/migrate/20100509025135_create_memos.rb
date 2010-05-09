class CreateMemos < ActiveRecord::Migration
  def self.up
    create_table :memos do |t|
      t.string :title
      t.text :note
      t.string :level

      t.timestamps
    end
  end

  def self.down
    drop_table :memos
  end
end
