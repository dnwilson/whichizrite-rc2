class UsersController < ApplicationController
	before_filter :authenticate_user!, only: [:index, :edit, :update, :destroy, :make_private, :make_public]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: :destroy

	def show
		@user = User.find(params[:id])
		# @users = @user.following_users.paginate(page: params[:page])
		if @user == current_user
			@stories = Story.stories_from_me(@user.id).paginate(page: params[:page])
		else
			@stories = @user.stories.paginate(page: params[:page])
		end
	end

	def index
		@users = User.paginate(page: params[:page])
	end

	# def search
	# 	@users = User.user_search(params[:query]).paginate(page: params[:page])
	# end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted"
		redirect_to :back
	end

	# def following
	#     @title = "Following"
	#     @user = User.find(params[:id])
	#     @users = @user.all_following.paginate(page: params[:page])
	#     render 'show_follow'
	# end

	# def followers
	#     @title = "Followers"
	#     @user = User.find(params[:id])
	#     @users = @user.followers.paginate(page: params[:page])
	#     render 'show_follow'
	# end

	# def follow
	# 	@user = User.find(params[:id])
	# 	current_user.follow(@user)
	# 	# RecommenderMailer.new_follower(@user).deliver if @user.notify_new_follower
	# 	redirect_to :back
	# 	flash[:success] = "You are now following #{@user.username}."
	# 	current_user.notify_follow(@user)
	# end

	# def unfollow
	# 	@user = User.find(params[:id])
	# 	current_user.stop_following(@user)
	# 	redirect_to :back
	# 	flash[:success] = "You are no longer following #{@user.username}."
	# 	current_user.notify_unfollow(@user)
	# end

	# def unpend
	# 	@user = User.find(params[:id])
	# 	current_user.unpend(@user)
	# 	redirect_to :back
	# 	flash[:success] = "You are no longer following #{@user.username}."
	# 	current_user.notify_pending(@user)
	# end


	# def make_private
	# 	@user = User.find(params[:id])
	# 	current_user.enable_privacy
	# 	redirect_to :back
	# 	flash[:notice] = "Your profile is now private"
	# end

	# def make_public
	# 	@user = User.find(params[:id])
	# 	current_user.disable_privacy
	# 	redirect_to :back
	# 	flash[:notice] = "Your profile is now public"
	# end

	private

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end

end