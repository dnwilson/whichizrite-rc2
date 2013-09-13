class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :post_id
      t.text :comment
      t.text :comment_html
      t.integer  :upcount,        :default => 0
      t.integer  :downcount,      :default => 0

      t.timestamps
    end
    add_index :comments, [:post_id, :user_id, :id] 
  end
end
