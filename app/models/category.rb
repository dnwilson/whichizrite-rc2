class Category < ActiveRecord::Base
  attr_accessible :cat_name, :id

  has_many :posts
end
