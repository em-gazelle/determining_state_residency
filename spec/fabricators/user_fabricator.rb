Fabricator(:user) do
	email Faker::Internet.email
	password "password"
	current_sign_in_at DateTime.now - 5.seconds
end