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
	birth_date = Faker::Date.between(7.months.ago, 8.months.ago)
	sex = [:wether, :wether, :wether, :ram, :ram, :ewe, :ewe, :ewe, :ewe, :teaser, :unknown].sample
	shepherds.each { |shepherd| shepherd.animals.create!(
													eartag: eartag,
													birth_date: birth_date,
													dam: shepherd.id+1000,
													sire: shepherd.id+2000,
													sex: sex,
													status: "active",
													status_date: birth_date
												)
									}
end

animals = Animal.order(:created_at)
animals.each {|animal| animal.weights.create!(
										date: animal.birth_date,
										weight_type: "birth",
										weight: Faker::Number.between(8,12)
									)
							}
animals.each {|animal| animal.weights.create!(
										date: 5.months.ago,
										weight_type: "weaning",
										weight: Faker::Number.between(50,70)
									)
							}


# Following relationships
shepherds = Shepherd.all
shepherd = shepherds.first
following = shepherds[2..50]
followers = shepherds[3..40]
following.each { |followed| shepherd.follow(followed) }
followers.each { |follower| follower.follow(shepherd) }
