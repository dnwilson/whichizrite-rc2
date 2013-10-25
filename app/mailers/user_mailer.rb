class UserMailer < ActionMailer::Base
	helper :application
	# helper :mailing
	default from: "info@damagecontrolhq.com"

	def welcome(user)
		@user = user
		mail(to: "#{user.name} <#{user.email}>", subject: "Registered")
	end

	# def forgot_password(user)
	# 	@user = user
	# 	mail(to: "#{user.name} <#{user.email}>", subject: "Password Recovery")
	# end

	def follow_alert(user, follower)
		@user = user
		@follower = follower
		if @user.settings.email_follow_alert == '1'
			mail(to: "#{user.name} <#{user.email}>", subject: "#{@follower.username} is now following you!")
		end
	end

	def profile_update(user)
		@user = user
		mail(to: "#{user.name} <#{user.email}>", subject: "Your profile was updated")
	end

	def post_comment(commenter, post)
		@commenter = commenter
		@post = post
		@user = @post.user
		if @user.settings.email_post_comment == '1' && @user != @commenter
			mail(to: "#{@user.name} <#{@user.email}>", subject: "#{@commenter.username} commented on your post")
		end
	end

	def post_vote(voter, post)
		@voter = voter
		@post = post
		@user = @post.user
		if @user.settings.email_post_vote == '1' && @user != @voter
			mail(to: "#{@user.name} <#{@user.email}>", subject: "#{@voter.username} voted on your post")
		end
	end

	def comment_vote(voter, comment)
		@voter = voter		
		@comment = comment
		@post = @comment.post
		@user = @comment.user
		if @user.settings.email_comment_vote == '1' && @user != @voter
			mail(to: "#{@user.name} <#{@user.email}>", subject: "#{@voter.username} voted on your comment")
		end
	end
end
