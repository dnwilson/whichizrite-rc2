class AddPMediaHtmlToPost < ActiveRecord::Migration
  def change
    add_column :posts, :p_media_html, :string
  end
end
