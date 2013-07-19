# == Schema Information
#
# Table name: assets
#
#  id                 :integer          not null, primary key
#  post_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Asset < ActiveRecord::Base
  attr_accessible :post_id
end
