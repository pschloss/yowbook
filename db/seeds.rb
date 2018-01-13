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

# create pedigree
shepherds.first.animals.create!(
												eartag: 1301,
												birth_date: 10.years.ago,
												sex: 'ewe',
												status: "active",
												status_date: 10.years.ago
											)

shepherds.first.animals.create!(
												eartag: 1302,
												birth_date: 10.years.ago,
												sex: 'ram',
												status: "active",
												status_date: 10.years.ago
											)

shepherds.first.animals.each { |animal| if animal.eartag != "1301" && animal.eartag != "1302"
																					animal.update(sire_eartag: "1302", dam_eartag: "1301")
																				end
}

# Following relationships
shepherds = Shepherd.all
shepherd = shepherds.first
following = shepherds[2..50]
followers = shepherds[3..40]
following.each { |followed| shepherd.follow(followed) }
followers.each { |follower| follower.follow(shepherd) }
