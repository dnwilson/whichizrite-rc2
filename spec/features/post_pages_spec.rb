require "spec_helper"

include Warden::Test::Helpers

Warden.test_mode!

describe "PostPages" do

	subject{page}

	let(:user){FactoryGirl.create(:user)}

	before {login_as(user, :scope => :user)}

	describe "post creation" do
		
		before{visit new_post_path}

		describe "with invalid information" do
			
			it "should not create a post" do
				expect{click_button "Post"}.should_not change(Post, :count)
			end

			it {have_selector('.post_category_id', text: "Blah")}
		end

		describe "with valid information" do
			

			before do
				fill_in 'post_p_title', 		with: "Lorem Ipsum"
				fill_in 'post_p_body',			with: "Lorm Ipsum"
				fill_in	'post_tag_list',		with: "test, anonymous"
				# select  Nokogiri::HTML('News').text, from: "post[category_id]"
				# check	'post_anonymous' 
			end

			it "should create a post" do
				# expect{click_button "Post"}.to change(Post, :count).by(1)
			end
		end
	end
end