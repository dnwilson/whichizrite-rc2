class SessionsController < Devise::
	def new
		@disable_chan = true
	end
end