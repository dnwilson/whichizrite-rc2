class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string   :p_type
      t.string   :p_title
      t.text     :p_body
      t.text     :p_body_html
      t.text     :p_media
      t.text     :p_media_html
      t.integer  :upcount,        :default => 0
      t.integer  :downcount,      :default => 0
      t.integer  :user_id
      t.integer  :origin_user_id
      t.boolean  :anonymous_post, :default => false
      t.integer  :category_id

      t.timestamps
    end

    add_index :posts, [:user_id, :id]
    add_index :posts, [:id, :category_id]
  end
end
