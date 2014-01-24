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
        @comment = current_user.comments.create(comment_params)
        @post = @comment.post
        @comment = :json
    end

	def create
        @comment = current_user.comments.create(comment_params)
        @post = @comment.post
     #    if @comment.user != current_user
	    #     # PrivatePub.publish_to("/#{@story.user_id}/alerts", "alert('#{current_user.username} commented on your post.');")
	    #     # current_user.notify_comment(@story)
	    # end
        respond_to do |format|
            format.html {redirect_to @comment.post}
            format.js
        end
        UserMailer.post_comment(current_user, @post).deliver 
    end

	def destroy
		@comment = Comment.find(params[:id])
		@comment.destroy
		redirect_to @comment.post
	end

	def vote_up
        @comment = Comment.find(params[:id])
        if @comment.user == current_user #|| @comment.user.private_followable == false || current_user.following?(@comment.user)
            if current_user.voted_against?(@comment)
                @comment.update_attribute("downcount", @comment.downcount - 1)
                @comment.update_attribute("upcount", @comment.upcount + 1)
                @comment.save
            else
                @comment.update_attribute("upcount", @comment.upcount + 1)
                @comment.save
            end
            # PrivatePub.publish_to("/#{@comment.user_id}/notifications", "alert('#{current_user.username} voted on your post.');")
            current_user.vote_exclusively_for(@comment)             
            # current_user.notify_vote(@comment)
            respond_to do |format|
                format.html { redirect_to @comment.post }
                format.js
            end            
            UserMailer.comment_vote(current_user, @comment).deliver
        else
            flash[:notice] = "You need to follow user in order to carry out this function"
            redirect_to user_path(@comment.user)
        end
    end

    def vote_down
        @comment = Comment.find(params[:id])
        if @comment.user == current_user #|| @comment.user.private_followable == false || current_user.following?(@comment.user)
            if current_user.voted_for?(@comment)
                @comment.update_attribute("upcount", @comment.upcount - 1)
                @comment.update_attribute("downcount", @comment.downcount + 1)
                @comment.save
            else
                @comment.update_attribute("downcount", @comment.downcount + 1)
                @comment.save
            end 
            # PrivatePub.publish_to("/#{@comment.user_id}/notifications", "alert('#{current_user.username} voted on your post.');")
            current_user.vote_exclusively_against(@comment)
            # current_user.notify_vote(@comment)
            respond_to do |format|
                format.html { redirect_to @comment.post}
                format.js
            end
            UserMailer.comment_vote(current_user, @comment).deliver
        else
            flash[:notice] = "You need to follow user in order to carry out this function"
            redirect_to user_path(@comment.user)
        end
    end

    def unvote
        @comment = Comment.find(params[:id])
        if @comment.user == current_user #|| @comment.user.private_followable == false || current_user.following?(@comment.user)
            if current_user.voted_for?(@comment)
                @comment.update_attribute("upcount", @comment.upcount - 1)
                @comment.save
            else
                @comment.update_attribute("downcount", @comment.downcount - 1)
                @comment.save
            end
            current_user.unvote_for(@comment)
            respond_to do |format|
                format.html { redirect_to @comment.post}
                format.js
            end
        else
            flash[:notice] = "You do not have permission to carry out this function."
            redirect_to root_path
        end
    end



	private
		def correct_user
			@comment = current_user.comments.find_by_id(params[:id])
 	      	redirect_to root_path if @comment.nil?
		end

        def comment_params
            params.require(:comment).permit(:comment, :comment_html, :post_id, :user_id)            
        end

end