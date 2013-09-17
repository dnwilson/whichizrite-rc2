module ApplicationHelper
	include AutoHtml

	def full_title(page_title)
		base_title = "whichizrite"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end		
	end

	def tag_cloud
		max = tags.sort_by(&:count).last
		tags.each do |tag|
			index = tag.count.to_f/max.count * (classes.size - 1)
			yield(tag, classes[index.round])
		end
	end

	def votecount(post)
		if post.votes_for == post.votes_against
			"-" 
	  	elsif post.votes_for > post.votes_against 
	  	  "#{post.votes_for - post.votes_against}"  
	  	else
	  	   "#{post.votes_against - post.votes_for}"
	  	end 
	end

	def avatar_for(user, style)
	  	t = style
	  	image_tag(user.avatar.url(t), class: "avatar")
	end

	def the_excerpt(post) 
		length = 160
		read_more_text = "Cont'd'"
		shortened = raw post.p_body.truncate(length, :separator => " ", :omission => "... #{link_to read_more_text, post_path(post), class:"continue"}")
		auto_html(shortened){simple_format; link(:target => 'blank')}
	end
end
