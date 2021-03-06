class PagesController < ApplicationController
  protect_from_forgery

  def home
  		@post = current_or_guest_user.posts.build
  		@categories = Category.all
  		@feed_items = Post.paginate(page: params[:page])
  		@featured_posts = Post.featured_posts
      @page_title = "whichizrite | be heard!"
      @page_url = "http://localhost:3000"
      @page_image = 'http://localhost:3000/assets/whichizrite.jpg'
  end

  def search
        @pg_search_documents = PgSearch.multisearch(params[:query])
        @query = params[:query]
        @posts = Post.all 
  end

end
