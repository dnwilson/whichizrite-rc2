class AddPImageUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :p_image_url, :string
  end
end
