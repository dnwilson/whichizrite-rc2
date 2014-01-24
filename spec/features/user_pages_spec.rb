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

	describe "password edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			visit login_path
			login_as(user, :scope => :user)
			visit settings_password_path(user)
		end
		describe "with valid password" do
			let(:current_password) { user.password }
			let(:new_password) { "foobar15" }
			before do
				fill_in "Current Password", 	with: current_password
				fill_in "New Password", 		with: new_password
				fill_in "Confirmation", 		with: new_password
				click_button "Update"
			end
			it{should have_title('whichizrite | Password')}
			it{should have_selector('div.alert.alert-success')}
		end

		describe "with invalid password" do
			let(:current_password) { "foob444" }
			let(:new_password) { "foobar15" }
			before do
				fill_in "Current Password", 	with: current_password
				fill_in "New Password", 		with: new_password
				fill_in "Confirmation", 		with: new_password
				click_button "Update"
			end
			it{should have_title('whichizrite | Password')}
			it{should have_selector('div#error_explanation')}
		end
	end

	describe "profile page" do
		
	end

	describe "signup page" do
		before{visit register_path}
		let(:submit) { "Sign up" }

		describe "with invalid info" do
			it "should not create a user" do
				expect {click_button submit}.not_to change(User, :count)
			end
		end

		describe "with valid info" do
			before do
				fill_in "Full Name",			with: "Dane Wilson"
				fill_in "Your Email",			with: "dane@whichizrite.com"
				fill_in "Password",				with: "foobar12"
				fill_in "Re-enter Password",	with: "foobar12"
				fill_in "Date of Birth",		with: "08/16/1985"
				find(:css, "#user_sex_male[value='Male']").set(true)
			end

			it "should create a user" do
				expect{click_button submit}.to change(User, :count).by(1)
			end			

			describe "after saving" do
				before{click_button submit}								
				it{should have_title(user.name)}
				it{should have_selector('div.alert.alert-success', text: 'Welcome to the community. Please remember to update your profile information.')}
			end
		end
	end
end