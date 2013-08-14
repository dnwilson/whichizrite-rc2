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
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post) }

  before do 
  	@comment = user.comments.create(comment: "Lorem ipsum", post_id: post.id )
  end

  subject{@comment}

  it{should respond_to(:comment)}
  it{should respond_to(:comment_html)}
  it{should respond_to(:post)}
  it{should respond_to(:user)}
  it{should respond_to(:votes)}
  it{should respond_to(:post_id)}
  its(:user){should == user}

  it{should be_valid}
end
