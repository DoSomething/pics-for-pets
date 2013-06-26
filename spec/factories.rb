FactoryGirl.define do
	factory :user do
		email "test@test.com"
		fbid 123
		uid 123
		is_admin false
	end
end