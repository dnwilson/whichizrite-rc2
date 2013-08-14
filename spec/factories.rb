FactoryGirl.define do
	factory :user do
		sequence(:email) {Forgery::Internet.email_address}
		sequence(:username) {Forgery::Internet.user_name}
		password				"foobar123"
		password_confirmation	"foobar123"

		factory :admin do
			admin true
		end
	end

	factory :post do
		sequence(:p_title) {|n| "Title #{n}" }
		p_body {Forgery::LoremIpsum.paragraphs(3)}
		category_id {[1, 2, 3, 4, 5, 6, 7, 8].sample}
		anonymous_post {Forgery::Basic.boolean}
		tag_list {Forgery::LoremIpsum.words(3)}
		user
	end
end