require "spec_helper"

include Warden::Test::Helpers

Warden.test_mode!

describe "UserPages" do
	
	subject{page}

	describe "logged in user profile page" do
		let(:user) { FactoryGirl.create(:user) }
		let!(:p1) { FactoryGirl.create(:post, user: user) }
		let!(:p2) { FactoryGirl.create(:post, user: user) }

		before(:each) do
			visit login_path
			login_as(user, :scope => :user)
		end

		before{visit user_path(user)}

		it{should have_selector('.about-user', text: "#{user.name}")}
		it{should_not have_selector('.follow_form')}

		describe "posts" do
			# it{should have_content(p1.p_title)}
			# it{should have_content(p2.p_body)}
		end


	end
end