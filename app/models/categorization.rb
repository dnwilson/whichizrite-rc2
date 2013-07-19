# == Schema Information
#
# Table name: categorizations
#
#  id          :integer          not null, primary key
#  post_id     :integer
#  category_id :integer
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Categorization < ActiveRecord::Base
  attr_accessible :category_id, :position, :post_id

  belongs_to :post
  belongs_to :category
end
