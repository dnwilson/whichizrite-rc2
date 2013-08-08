class AddOriginUserIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :origin_user_id, :integer
  end
end
