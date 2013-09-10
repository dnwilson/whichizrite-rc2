class AddPMediaToPost < ActiveRecord::Migration
  def change
    add_column :posts, :p_media, :string
  end
end
