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

User.create!(name: 'anonymous', 
					username: 'anonymous',
					email: 'anonymous@whichizrite.com',
					password: '1@mDamage', 
					password_confirmation: '1@mDamage',
					location: 'Unknown',
					aboutme: 'Unknown'
					)

User.create!(name: 'Information', 
					username: 'Information',
					email: 'tester@whichizrite.com',
					password: '1@mDamage', 
					password_confirmation: '1@mDamage',
					sex: 'male',
					location: 'Kingston, Jamaica',
					aboutme: 'This is whichizrite. Be heard')

user1 = User.create(name: 'Guest', 
					username: 'guest',
					email: 'guest@whichizrite.com'
					)
user1.save!(:validate => false)