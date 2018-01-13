s = Shepherd.first
ewe = s.animals.find_by(id: 211)
ewe.update(sex: 'ewe')

ram = s.animals.find_by(id: 199)
ram.update(sex: 'ram')

lamb_one = s.animals.find_by(id: 61)
lamb_two = s.animals.find_by(id: 169)
lamb_three = s.animals.find_by(id: 187)

lamb_one.update(dam_id: 211, sire_id: 199)
lamb_two.update(dam: ewe, sire: ram)
lamb_three.update(dam_eartag: ewe.eartag, sire_eartag: ram.eartag)
