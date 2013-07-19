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

require 'spec_helper'

describe Categorization do
  pending "add some examples to (or delete) #{__FILE__}"
end
