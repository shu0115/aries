class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :name
      t.string :twitter_id
      t.date :birthday
      t.string :blog_url
      t.string :website_url

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
