# == Schema Information
#
# Table name: comments
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  post_id      :integer
#  comment      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  comment_html :string(255)
#  upcount      :integer          default(0)
#  downcount    :integer          default(0)
#

require 'spec_helper'

describe Comment do
  pending "add some examples to (or delete) #{__FILE__}"
end
