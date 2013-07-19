# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create!(cat_name:"Exclusive")
Category.create!(cat_name:"News")
Category.create!(cat_name:"Jokes")
Category.create!(cat_name:"Rumors")
Category.create!(cat_name:"Music")
Category.create!(cat_name:"Videos")
Category.create!(cat_name:"Events")
Category.create!(cat_name:"Opinions")

user6= User.create!(name: 'Fiyah Damage', 
					about_me: 'CEO of Damage Control & whichizrite', 
					username: 'fireras', 
					avatar: File.open(File.join(Rails.root, 'sampleimages/', 'fiyah.jpg')), 
					sex: 'male',
					location: 'Brooklyn, NY', 
					email: 'fireras@gmail.com', 
					password: 'm0nalisa', 
					password_confirmation: 'm0nalisa'
)

user6.posts.create!(
	p_title: 'Stop Watch',
	p_body: 'This is a post about a stop watch that I am wearing on my hand. It is from casio',
	category_id: 3,
	tag_list: 'stopwatch, hand, image',
	p_image: File.open(File.join(Rails.root, 'sampleimages', 'watch.jpg'))					
)

user6.posts.create!(
	p_title: 'Weed of the Nation',
	p_body: 'This is a post about a weed tree I took a picture of. How nice!',
	category_id: 1,
	tag_list: 'weed, plant, image',
	p_image: File.open(File.join(Rails.root, 'sampleimages', 'weed.jpg'))
					
)

user6.posts.create!(
	p_title: 'Fat P***y Model Bitch',
	p_body: 'Check out this sexy model that I got a picture of.',
	category_id: 2,
	tag_list: 'model, sexy, girls',
	p_image: File.open(File.join(Rails.root, 'sampleimages', 'model.jpg'))
					
)


user1 = User.create!(name: 'whichizrite', 
					username: 'whichizrite',
					email: 'info@whichizrite.com',
					password: '1@mDamage', 
					password_confirmation: '1@mDamage',
					sex: 'male',
					location: 'Kingston, Jamaica',
					about_me: 'This is whichizrite. Be heard'
					)

user1.posts.create!(
	p_title: 'I Love The Reggae Boyz',
	p_body: 'The Jamaica National Football Team',
	category_id: 5,
	tag_list: 'football, jamaica, reggaeboyz',
	p_image: File.open(File.join(Rails.root, 'sampleimages', 'reggaeboyz.jpg'))
					
)

user1.posts.create!(
	p_title: 'Foam Party',
	p_body: 'An image from Damage Control Foam Party in 2011',
	category_id: 3,
	tag_list: 'foam, party, damagecontrol',
	p_image: File.open(File.join(Rails.root, 'sampleimages', 'reggaeboyz.jpg'))
					
)

user2 = User.create!(name: 'Razor Damage', 
					username: 'razordamage',
					email: 'razor@whichizrite.com',
					password: 'foobar12', 
					password_confirmation: 'foobar12',
					sex: 'male',
					location: 'Kingston, Jamaica',
					about_me: 'My name is Razor Damage',
					avatar: File.open(File.join(Rails.root, 'sampleimages', 'razor.jpg'))
					)

user2.posts.create!(
	p_title: 'Random Post',
	p_body: 'This post is so damn random it could be anything',
	category_id: 1,
	tag_list: 'random, stuff',					
)

user2.posts.create!(
	p_title: 'Me @ International Swagg',
	p_body: 'Me looking oh so swagged out at International Swagg in March 2013',
	category_id: 2,
	tag_list: 'swagg, party, march',
	p_image: File.open(File.join(Rails.root, 'sampleimages', 'swagg.jpg'))
					
)

user3 = User.create!(name: 'Browning', 
					username: 'browning',
					email: 'browning@whichizrite.com',
					password: 'foobar12', 
					password_confirmation: 'foobar12',
					sex: 'female',
					location: 'Miami, FL',
					about_me: 'My name is browning',
					avatar: File.open(File.join(Rails.root, 'sampleimages', 'browning.jpg'))
					)

user3.posts.create!(
	p_title: 'I Love Me Some Food',
	p_body: 'A pic of some food I had while at coalstove in Jamaica',
	category_id: 6,
	tag_list: 'coalstove, food, jamaica',
	p_image: File.open(File.join(Rails.root, 'sampleimages', 'food.jpg'))
)

user3.posts.create!(
	p_title: 'The Big Clock',
	p_body: 'The very famous clocktower in H.W.T, St. Andrew',
	category_id: 7,
	tag_list: 'clock, hwt, jamaica',
	p_image: File.open(File.join(Rails.root, 'sampleimages', 'bigclock.jpg'))
)

user5 = User.create!(name: 'Fal Gal', 
					username: 'fatgal',
					email: 'fatgal@whichizrite.com',
					password: 'foobar12', 
					password_confirmation: 'foobar12',
					sex: 'female',
					location: 'London, England',
					about_me: 'My name is browning',
					avatar: File.open(File.join(Rails.root, 'sampleimages', 'fatgal.jpg'))
					)

user5.posts.create!(
	p_title: 'Half Way Tree',
	p_body: 'I dont even know if this is Half Way Tree but the pic is nice',
	category_id: 4,
	tag_list: 'hwt, random, jamaica',
	p_image: File.open(File.join(Rails.root, 'sampleimages', 'hwt.jpg'))
)

user5.posts.create!(
	p_title: 'Test Post No Pic',
	p_body: 'This is a test post that has no images',
	category_id: 2,
	tag_list: 'test, no image'
)

user4 = User.create(name: 'Guest', 
					username: 'guest',
					email: 'guest@whichizrite.com'
					)
user4.save!(:validate => false)

user6.follow(user1)
user6.follow(user2)
user6.follow(user3)
user6.follow(user5)

user1.follow(user2)
user1.follow(user3)
user1.follow(user5)
user1.follow(user6)

user2.follow(user1)
user2.follow(user3)
user2.follow(user5)
user2.follow(user6)

user3.follow(user2)
user3.follow(user1)
user3.follow(user5)
user3.follow(user6)

user5.follow(user2)
user5.follow(user3)
user5.follow(user1)
user5.follow(user6)