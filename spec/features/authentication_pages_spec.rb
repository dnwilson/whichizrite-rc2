require 'spec_helper'

include Devise::TestHelpers

describe "AuthenticationPages" do
	
	subject{page}
	
	describe "login page" do
		before{visit login_path}

		it{should have_selector('h3', text: 'Login')}
		it{should have_title('whichizrite | login')}
	end

	describe "Login" do
		before{visit login_path}

		describe "with invalid information" do
			
			it{should have_title('whichizrite | login')}
			# it{should have_selector '.alert'}
		end

		describe "with valid email information" do
			let(:user){FactoryGirl.create(:user)}

			before do
				fill_in "username/email", 	with: user.email
				fill_in "password", with: user.password
				click_button "Login"
			end

			it{should have_selector('li.active', text: "Latest")}
			it{should have_selector('.posts')}
		end

		describe "with valid username information" do
			let(:user){FactoryGirl.create(:user)}

			before do
				fill_in "username/email", 	with: user.username
				fill_in "password", 		with: user.password
				click_button "Login"
			end

			it{should have_selector('li.active', text: "Latest")}
			it{should have_selector('.posts')}
		end
	end
end