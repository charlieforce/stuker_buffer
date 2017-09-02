class AddSendToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :send, :integer
    add_column :posts, :end_time, :datetime
    remove_column :posts, :send_now
  end
end
