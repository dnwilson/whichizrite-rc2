class CommentsController < ApplicationController

	before_filter :authenticate_user!
	before_filter :correct_user, only: :destroy

	# def create
	# 	# @comments = Comment.all
	# 	@comment = current_user.comments.create(params[:comment])
	# 	@story = @comment.story
	# 	respond_to do |format|
 #            format.html {redirect_to @comment.story}
 #            format.js
 #        end
	# end

	def new
        @comment = current_user.comments.create(params[:comment])
        @post = @comment.post
        @comment = :json
    end

	def create
        @comment = current_user.comments.create(params[:comment])
        @post = @comment.post
     #    if @post.user != current_user
	    #     # PrivatePub.publish_to("/#{@story.user_id}/alerts", "alert('#{current_user.username} commented on your post.');")
	    #     # current_user.notify_comment(@story)
	    # end
        respond_to do |format|
            format.html {redirect_to @comment.post}
            format.js
        end
    end

	def destroy
		@comment = Comment.find(params[:id])
		@comment.destroy
		redirect_to @comment.post
	end



	private
		def correct_user
			@comment = current_user.comments.find_by_id(params[:id])
 	      	redirect_to root_path if @comment.nil?
		end

end