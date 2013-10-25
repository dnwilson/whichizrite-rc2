 class UsersController < ApplicationController
	before_filter :authenticate_user!, only: [:index, :edit, :update, :destroy, :make_private, :make_public]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: :destroy

	def show
		@user = User.friendly.find(params[:id])
		if current_user == @user
			@feed_items = @user.myfeed.paginate(page: params[:page])
		else
			@feed_items = @user.posts.paginate(page: params[:page])
		end
	end

	def index
		@users = User.paginate(page: params[:page])
	end

	# def search
	# 	@users = User.user_search(params[:query]).paginate(page: params[:page])
	# end

	def destroy
		User.friendly.find(params[:id]).destroy
		flash[:success] = "User deleted"
		redirect_to :back
	end

	def following
	    @title = "Following"
	    @user = User.friendly.find(params[:id])
	    @users = @user.following_users.paginate(page: params[:page], per_page: 10)
	    render 'show_follow'
	end

	def followers
	    @title = "Followers"
	    @user = User.friendly.find(params[:id])
	    @users = @user.followers.paginate(page: params[:page], per_page: 10)
	    render 'show_followers'
	end

	def follow
		@user = User.friendly.find(params[:id])
		if current_or_guest_user.name == "Guest"
            flash[:notice] = "You need to be signed in to follow a user"
            redirect_to login_path
        else
            current_user.follow(@user)
			# RecommenderMailer.new_follower(@user).deliver if @user.notify_new_follower
			UserMailer.follow_alert(current_user, @user).deliver
			redirect_to :back
			flash[:notice] = "You are now following #{@user.username}."
			# current_user.notify_follow(@user)
        end		
	end

	def unfollow
		@user = User.friendly.find(params[:id])		
		if current_or_guest_user.name == "Guest"
            flash[:notice] = "You need to be signed in to unfollow a user"
            redirect_to login_path
        else
            current_user.stop_following(@user)
			redirect_to :back
			flash[:success] = "You are no longer following #{@user.username}."
			# current_user.notify_unfollow(@user)
        end	
	end

	def unpend
		@user = User.friendly.find(params[:id])
		current_user.unpend(@user)
		redirect_to :back
		flash[:success] = "You are no longer following #{@user.username}."
		# current_user.notify_pending(@user)
	end


	def visibility
		# @user = User.friendly.find(params[:id])
		current_user.modify_pref('hide_profile')
		if current_user.is_set_to?('hide_profile')
			redirect_to :back
			flash[:notice] = "Your profile is now private"
		else
			redirect_to :back
			flash[:notice] = "Your profile is now public"
		end		
	end

	private

		def correct_user
			@user = User.friendly.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end


end