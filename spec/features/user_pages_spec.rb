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

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			visit login_path
			login_as(user, :scope => :user)
			visit settings_path(user)
		end
		describe "with valid info" do
			let(:new_location) { "Testerville, TS" }
			let(:new_aboutme) { "I am a tester" }
			before do
				fill_in "Location", 	with: new_location
				fill_in "Aboutme", 		with: new_aboutme
				click_button "Update"
			end
			it{should have_title('whichizrite | Profile Settings')}
			it{should have_selector('div.alert.alert-success')}
			# it{should have_link("Sign out", href: logout_path)}
			specify {expect(user.reload.location).to eq new_location}
			specify {expect(user.reload.aboutme).to eq new_aboutme}
		end
	end
end