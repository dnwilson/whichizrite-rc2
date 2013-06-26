class PagesController < ApplicationController
  protect_from_forgery

  def home
  		@post = current_or_guest_user.posts.build
  		@categories = Category.all
  		@feed_items = Post.paginate(page: params[:page])
  		@featured_posts = Post.featured_posts
  end

end
