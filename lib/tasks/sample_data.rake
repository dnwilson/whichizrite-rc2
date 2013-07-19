namespace :db do 
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_posts
		make_relationships
	end
end

def make_users
	9.times do |n|
		name = Faker::Name.name
		email = "example-#{n+15}@whichizrite.com"
		password = "password"
		sex = ["male", "female"].sample
		location = ["Brooklyn", "Kingston", "New York", "Paris", "London", "Miami", "Los Angeles"].sample
		avatar = File.open(Dir.glob(File.join(Rails.root, 'sampleimages', '*')).sample)
		User.create!(name: name,
					 email: email,
					 password: password,
					 password_confirmation: password,
					 avatar: avatar)
	end
end

def make_posts
	users = User.all(limit:6)
	5.times do
		content = Faker::Lorem.sentence(5)
		title = "#{Faker::Lorem.words(2)}"
		pic = File.open(Dir.glob(File.join(Rails.root, 'sampleimages', '*')).sample)
		category = [1, 2, 3, 4, 5, 6, 7, 8].sample
		tags = "#{Faker::Name.first_name}, #{Faker::Name.first_name}, #{Faker::Name.first_name}"
		users.each {|user| user.posts.create!(p_title: title, 
											  p_body: content, 
											  tag_list: tags,
											  category_id: category,
											  p_image: pic)}
	end
end

def make_relationships
	users = User.all
	user = users.first
	followed_users = users[2..10]
	followers 	= users[3..10]
	followed_users.each{ |followed| user.follow(followed)}
	followers.each {|follower| follower.follow(user)}
end