class RenameSendToPosts < ActiveRecord::Migration
  def change
  	rename_column :posts, :send, :sending_mode
  end
end
