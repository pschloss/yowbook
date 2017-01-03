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

# Animals
shepherds = Shepherd.order(:created_at).take(6)
for i in 1..50 do
	eartag = 1600 + i
	birth_date = Faker::Date.between(10.months.ago, 8.months.ago)
	sex = [:wether, :wether, :wether, :ram, :ram, :ewe, :ewe, :ewe, :ewe, :teaser, :unknown].sample
	shepherds.each { |shepherd| shepherd.animals.create!(
													eartag: eartag,
													birth_date: birth_date,
													dam: shepherd.id+1000,
													sire: shepherd.id+2000,
													sex: sex) }
end

# Following relationships
shepherds = Shepherd.all
shepherd = shepherds.first
following = shepherds[2..50]
followers = shepherds[3..40]
following.each { |followed| shepherd.follow(followed) }
followers.each { |follower| follower.follow(shepherd) }
