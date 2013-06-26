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
		p_category {Forgery::LoremIpsum.words(1)}
		anonymous_post {Forgery::Basic.boolean}
		user
	end
end