class PostsController < ApplicationController
	before_filter :authenticate_user!, only: [:create, :destroy, :vote_up, :vote_down]
    before_filter :correct_user, only: :destroy
    skip_before_filter :verify_authenticity_token, :only => [:vote_up, :vote_down, :unvote]    
	def show
		@post = Post.friendly.find(params[:id])
        @comment = Comment.new
        @categories = Category.all
        @page_title = @post.p_title
        @page_url = "http://localhost:3000"+ post_path(@post)
        @page_type = @post.p_type
        if @post.p_type == 'image'
            @page_image = @post.p_image
        else
            @page_image = 'http://localhost:3000/assets/whichizrite.jpg'
        end
		respond_to do |format|
            format.html # show.html.erb
        end  
	end

    def index
        if params[:tag]
            @posts = Post.tagged_with(params[:tag])
        elsif params[:query]
            @pg_search_documents = PgSearch.multisearch(params[:query])
            @query = params[:query]
            @posts = Post.all 
        else
            @posts = Post.cat_list(params[:category])
        end       
    end

    def new
        if current_or_guest_user.name == "Guest"
            flash[:notice] = "You need to login before you can create a post."
            redirect_to root_path
        else
            @post = current_user.posts.build(post_params)
            @categories = Category.all
        end
    end
    
    def destroy
        @post = Post.friendly.find(params[:id])
        @post.destroy

        flash[:notice] = "Post successfully deleted."
        redirect_to root_path
    end

	def create
		@post = current_user.posts.build(post_params)
        @categories = Category.all
        if @post.anonymous_post? 
            @post.user_id = User.find_by_username('anonymous').id
            @post.origin_user_id = current_user.id
        else
            @post.origin_user_id = current_user.id
        end

		respond_to do |format|
        	if @post.save 
                current_user.fb_publish(@post.p_title, post_path(@post))
                format.html {redirect_to root_path, :notice => "Post created!"}
                format.json {render json: @post, status: :created, location: @post}
                format.js
        	else
                # @feed_items = []
                format.html {render 'posts/new'}
                format.json {render json: @post.errors, status: :unprocessable_entity}
                format.js {render 'posts/new'}
        	end
        end
	end

    # def edit
    #     if current_or_guest_user.name == "Guest"
    #         flash[:notice] = "You do not have permission to carry out this function."
    #         redirect_to root_path
    #     else
    #         @post = Post.friendly.find(params[:id])
    #         @categories = Category.all
    #     end        
    # end

    # def update
    #     @post = Post.friendly.find(params[:id])
    #     respond_to do |format|
    #         if @post.update_attributes(post_params) 
    #             current_user.fb_publish(@post.p_title, post_path(@post))
    #             format.html {redirect_to root_path, :notice => "Post updated!"}
    #             format.json {render json: @post, status: :created, location: @post}
    #             format.js
    #         else
    #             # @feed_items = []
    #             format.html {render 'posts/new'}
    #             format.json {render json: @post.errors, status: :unprocessable_entity}
    #             format.js {render 'posts/new'}
    #         end
    #     end        
    # end

    def vote_up
        @post = Post.friendly.find(params[:id])
        if current_or_guest_user == "Guest"
            flash[:notice] = "You do not have permission to carry out this function."
            redirect_to root_path
        else
            if @post.user == current_user || @post.user.private_followable == false || current_user.following?(@post.user)
                if current_user.voted_against?(@post)
                    @post.update_attribute("downcount", @post.downcount - 1)
                    @post.update_attribute("upcount", @post.upcount + 1)
                    @post.save
                else
                    @post.update_attribute("upcount", @post.upcount + 1)
                    @post.save
                end
                # PrivatePub.publish_to("/#{@post.user_id}/notifications", "alert('#{current_user.username} voted on your post.');")
                current_user.vote_exclusively_for(@post)              
                respond_to do |format|
                    format.html { redirect_to @post }
                    format.js
                end
                current_user.fb_publish(@post.p_title, post_path(@post))
                UserMailer.post_vote(current_user, @post).deliver  
            else
                flash[:notice] = "You need to follow user in order to carry out this function"
                redirect_to user_path(@post.user)
            end
        end
    end

    def vote_down
        @post = Post.friendly.find(params[:id])
        if current_or_guest_user == "Guest"
            flash[:notice] = "You do not have permission to carry out this function."
            redirect_to root_path
        else
            if @post.user == current_user || @post.user.private_followable == false || current_user.following?(@post.user)
                if current_user.voted_for?(@post)
                    @post.update_attribute("upcount", @post.upcount - 1)
                    @post.update_attribute("downcount", @post.downcount + 1)
                    @post.save
                else
                    @post.update_attribute("downcount", @post.downcount + 1)
                    @post.save
                end 
                # PrivatePub.publish_to("/#{@post.user_id}/notifications", "alert('#{current_user.username} voted on your post.');")
                current_user.vote_exclusively_against(@post)
                # current_user.notify_vote(@post)
                respond_to do |format|
                    format.html { redirect_to @post}
                    format.js
                end
                current_user.fb_publish(@post.p_title, post_path(@post))
                UserMailer.post_vote(current_user, @post).deliver 
            else
                flash[:notice] = "You need to follow user in order to carry out this function"
                redirect_to user_path(@post.user)
            end
        end
    end

    def unvote
        @post = Post.friendly.find(params[:id])
        if current_or_guest_user == "Guest"
            flash[:notice] = "You do not have permission to carry out this function."
            redirect_to root_path
        else
            if @post.user == current_user || @post.user.private_followable == false || current_user.following?(@post.user)
                if current_user.voted_for?(@post)
                    @post.update_attribute("upcount", @post.upcount - 1)
                    @post.save
                else
                    @post.update_attribute("downcount", @post.downcount - 1)
                    @post.save
                end
                current_user.unvote_for(@post)
                respond_to do |format|
                    format.html { redirect_to @post}
                    format.js
                end
            else
                flash[:notice] = "You do not have permission to carry out this function."
                redirect_to root_path
            end
        end        
    end

    private
        def correct_user
            @post = current_user.id == Post.friendly.find(params[:id]).origin_user_id
            redirect_to root_url if @post.nil?            
        end

        def post_params
            params.fetch(:post, {}).permit(:p_title, :p_image, :p_image_url, :anonymous_post, :p_body, 
                                         :p_body_html, :p_media, :p_type, :category_id,
                                         :tag_list, :upcount, :downcount, :origin_user_id)
        end

        def tag_params
            params.require(:tag).permit(:name)
        end

        def category_params
            params.fetch(:category, {}).permit(:cat_name)
        end

end