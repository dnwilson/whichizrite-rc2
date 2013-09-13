class Category < ActiveRecord::Base
  # attr_accessible :cat_name, :id

  has_many :posts

  def post_list(id)
  	Category.find(id).posts
  end
end
