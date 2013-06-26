# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  title      :string(255)
#  body       :text
#  user_id    :integer
#  anonymous  :boolean          default(FALSE)
#  category   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Post do
	let(:user) { FactoryGirl.create(:user) }
	before{@post = user.posts.build(p_title: Forgery::LoremIpsum.words(1),
									p_body: Forgery::LoremIpsum.paragraphs(3),
									p_category: Forgery::LoremIpsum.words(1),
									anonymous_post: Forgery::Basic.boolean
									)}
	
	subject{@post}

	it{should respond_to(:p_title)}
	it{should respond_to(:p_body)}
	it{should respond_to(:p_category)}
	it{should respond_to(:anonymous_post)}
	it{should respond_to(:user_id)}
	it{should respond_to(:user)}
	its(:user){should == user}

	it{should be_valid}
end
