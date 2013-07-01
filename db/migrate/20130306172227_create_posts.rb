class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :p_type
      t.string :p_title
      t.text :p_body
      t.integer :user_id
      t.boolean :anonymous_post, :default => false
      t.integer :cat_id

      t.timestamps
    end

    add_index :posts, [:user_id, :id]
    add_index :posts, [:id, :cat_id]
  end
end
