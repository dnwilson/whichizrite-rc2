class AddThumbsUpToComments < ActiveRecord::Migration
  def change
  	add_column :comments,		:upcount , 			:integer, :default => 0
  	add_column :comments, 		:downcount , 		:integer, :default => 0
  end
end
