namespace :db do 
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_posts
		make_comments
		make_votes
		make_relationships
	end
end

def make_users
	admin = User.create!(name: 	"whichizrite",
			 email: 		"ad@whichizrite.com",
			 password: 		"m0nalisa",
			 password_confirmation: "m0nalisa")
	admin.toggle!(:admin)
	99.times do |n|
		name = Faker::Name.name
		email = "example-#{n+1}@railstutorial.org"
		password = "password"
		sex = ["Male", "Female"].sample
		aboutme = Faker::Lorem.sentence(2)
		avatar = File.open(Dir.glob(File.join(Rails.root, 'sampleimages/avatars', '*')).sample)
		User.create!(name: name,
					 email: email,
					 password: password,
					 password_confirmation: password,
					 sex: sex,
					 aboutme: aboutme,
					 avatar: avatar)
	end
end

def make_posts
	users = User.all(limit:6)
	50.times do
		p_title = Faker::Lorem.word
		p_body = Faker::Lorem.sentence(5)
		category_id = [1, 2, 3, 4, 5, 6, 7, 8].sample
		anonymous_post = [true, false].sample
		image = File.open(Dir.glob(File.join(Rails.root, 'sampleimages/postimage', '*')).sample)
		tag_list = "#{Faker::Lorem.word}, #{Faker::Lorem.word}, #{Faker::Lorem.word}"
		users.each {|user| user.posts.create!(p_title: p_title,
			p_body: p_body, category_id: category_id, 
			anonymous_post: anonymous_post, tag_list: tag_list, p_image: image)}
	end
end

def make_comments
	users = User.all(limit:6)
	user = users.first
	posts = Post.all 
	post = posts.first
	50.times do
		comment = Faker::Lorem.sentence(2)
		posts.each {|post| user.comments.create!(comment: comment, post_id: post.id)}
	end
end


def make_relationships
	users = User.all
	user = users.first
	followed_users = users[2..50]
	followers 	= users[3..40]
	followed_users.each{ |followed| user.follow(followed)}
	followers.each {|follower| follower.follow(user)}
end

def make_votes
	users = User.all
	user = users.first
	posts = Post.all
	posts_for = posts[2..50]
	posts_against = posts[3..40]
	posts_for.each{ |posts_for| user.vote_for(posts_for)}
end