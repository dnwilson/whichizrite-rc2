# require "spec_helper"

include Devise::TestHelpers

describe "UsersController" do

	describe "facebook authentication" do
		before do
			request.env["devise.mapping"] = Devise.mappings[:user]
			request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
		end

		# it "sets a session variable to the OmniAuth auth hash" do
		# 	request.env["omniauth.auth"][:uid].to eq '1234'
		# end
	end
	
end