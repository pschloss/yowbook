a = Shepherd.first.animals.first
w = Weight.new(animal_id: a.id, weight: 10, weight_type: "birth", date: a.birth_date)
w.save
w = Weight.new(animal_id: a.id, weight: 45, weight_type: "weaning", date: a.birth_date+55)
w.save
