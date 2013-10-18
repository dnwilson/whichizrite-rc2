require 'spec_helper'

include Devise::TestHelpers

describe User do
	before {@user = User.new( name: "This Person",
							  email: "user@example.com",
							  password: "foobar12",
							  password_confirmation: "foobar12",
							  dob: "12/12/2001",
							  sex: "female"
							  )}

	subject{@user}

	it{should respond_to(:name)}
	it{should respond_to(:email)}
	it{should respond_to(:password)}
	it{should respond_to(:password_confirmation)}
	it{should respond_to(:dob)}
	it{should respond_to(:sex)}
	it{should respond_to(:location)}
	it{should respond_to(:aboutme)}
	it{should respond_to(:aboutme_html)}
	it{should respond_to(:provider)}
	it{should respond_to(:uid)}
	it{should respond_to(:private_followable)}
	it{should respond_to(:country_name)}
	it{should respond_to(:posts)}
	it{should respond_to(:votes)}
	it{should respond_to(:comments)}
	it{should respond_to(:feed)}
	it{should respond_to(:facebook)}
	it{should respond_to(:fbconnect)}

	it{should be_valid}
	it{should_not be_admin}


	describe "post associations" do

		before {@user.save}
		let!(:older_post) do
			FactoryGirl.create(:post, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_post) do
			FactoryGirl.create(:post, user: @user, created_at: 1.day.ago)
		end

		it "should have the right posts in the right order" do
			expect(@user.posts.to_a).to eq [newer_post, older_post]
		end

		it "should destroy associated posts" do
			 posts = @user.posts
			 @user.destroy
			 posts.each do |post|
			 	Post.find_by_id(post.id).should be_nil
			 end
		end

		describe "new post" do
			let(:unfollowed_post) { FactoryGirl.create(:post, user: FactoryGirl.create(:user)) }
			let(:private_user_unfollowed_post) { FactoryGirl.create(:post, user: FactoryGirl.create(:user, private_followable: true)) }

			let(:followed_user) { FactoryGirl.create(:user) }

			before do
				@user.follow(followed_user)
				3.times{followed_user.posts.create!(
					p_title: "Lorem ipsum",
					p_body: "Lorem ipsum",
					category_id: [1, 2, 3, 4, 5, 6, 7, 8].sample,
					tag_list: Forgery::LoremIpsum.words(3))}
			end

			its(:feed) { should_not include (unfollowed_post) }
			its(:feed) do
				followed_user.posts.each do |post|
					should include {post}
				end
			end
		end
	end
end
