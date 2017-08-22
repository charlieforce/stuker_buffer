class AddSendNowToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :send_now, :boolean
  end
end
