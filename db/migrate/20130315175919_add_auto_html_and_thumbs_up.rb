class AddAutoHtmlAndThumbsUp < ActiveRecord::Migration
  def change
  	add_column :posts,		:upcount , 			:integer, :default => 0
  	add_column :posts, 		:downcount , 		:integer, :default => 0
  	add_column :posts, 		:p_body_html,		:string
  	add_column :comments, 	:comment_html, 		:string
  end
end
