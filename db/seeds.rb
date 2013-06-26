# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: 'Fiyah Damage', username: "fireras", email: "fireras@gmail.com", password: "m0nalisa", password_confirmation: "m0nalisa")
Category.create!(cat_name:"Exclusive")
Category.create!(cat_name:"News")
Category.create!(cat_name:"Jokes")
Category.create!(cat_name:"Rumors")
Category.create!(cat_name:"Music")
Category.create!(cat_name:"Videos")
Category.create!(cat_name:"Events")
Category.create!(cat_name:"Opinions")

user1 = User.create!(name: 'whichizrite', 
					username: 'whichizrite',
					email: 'info@whichizrite.com',
					password: '1@mDamage', 
					password_confirmation: '1@mDamage'
					)
user2 = User.create(name: 'Guest', 
					username: 'guest',
					email: 'guest@whichizrite.com'
					)
user2.save!(:validate => false)