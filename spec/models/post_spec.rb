# == Schema Information
#
# Table name: posts
#
#  id                   :integer          not null, primary key
#  p_type               :string(255)
#  p_title              :string(255)
#  p_body               :text
#  user_id              :integer
#  anonymous_post       :boolean          default(FALSE)
#  category_id          :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  p_image_file_name    :string(255)
#  p_image_content_type :string(255)
#  p_image_file_size    :integer
#  p_image_updated_at   :datetime
#  upcount              :integer          default(0)
#  downcount            :integer          default(0)
#  p_body_html          :string(255)
#  origin_user_id       :integer
#

require 'spec_helper'

include Devise::TestHelpers

describe Post do
	let(:user) { FactoryGirl.create(:user) }
	before{@post = user.posts.build(
					p_title: "Lorem ipsum",
					p_body: "Lorem ipsum",
					category_id: [1, 2, 3, 4, 5, 6, 7, 8].sample,
					tag_list: Forgery::LoremIpsum.words(3))}

	subject{@post}

	it{should respond_to(:p_title)}
	it{should respond_to(:p_body)}
	it{should respond_to(:p_body_html)}
	it{should respond_to(:category_id)}
	it{should respond_to(:anonymous_post)}
	it{should respond_to(:upcount)}
	it{should respond_to(:downcount)}
	it{should respond_to(:origin_user_id)}
	it{should respond_to(:user_id)}
	it{should respond_to(:user)}
	it{should respond_to(:tag_list)}
	it{should respond_to(:tags)}
	it{should respond_to(:comments)}
	it{should respond_to(:votes)}
	it{should respond_to(:votecount)}
	its(:user){should == user}

	it{should be_valid}

	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do 
				Post.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "when user_id is not present" do
		before{@post.user_id = nil}
		it{should_not be_valid}
	end

	describe "with blank title" do
		before{@post.p_title = nil}
		it{should_not be_valid}
	end

	describe "with blank body and no image" do
		before{@post.p_body = nil || @post.p_image = nil}
		it{should_not be_valid}
	end
end
