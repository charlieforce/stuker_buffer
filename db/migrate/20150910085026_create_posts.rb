class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content      
      t.datetime :scheduled_at
      t.string :state
      t.integer :user_id
      t.boolean :facebook
      t.boolean :twitter
      t.boolean :google_oauth2
      t.boolean :instagram
      t.boolean :pinterest
      t.boolean :tumblr      

      t.timestamps null: false
    end
  end
end
