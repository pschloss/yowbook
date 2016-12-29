Shepherd.create!(name:             "Example Shepherd",
						username:              "Example",
						email:                 "example@railstutorial.org",
						password:              "foobar",
						password_confirmation: "foobar",
						admin:                 true,
						activated:             true,
						activated_at:          Time.zone.now)

99.times do |n|
	name = Faker::Name.name
	email = "example-#{n+1}@railstutorial.org"
	password = "password"
	Shepherd.create!(	name:              name,
								username:              "Example_#{n+1}",
								email:                 email,
								password:              password,
								password_confirmation: password,
								activated:             true,
								activated_at:          Time.zone.now)
end

shepherds = Shepherd.order(:created_at).take(6)
50.times do
	eartag = Faker::Number.number(4)
	birth_date = Faker::Date.between(10.months.ago, 8.months.ago)
	shepherds.each { |shepherd| shepherd.animals.create!(eartag: eartag, birth_date: birth_date) }
end
