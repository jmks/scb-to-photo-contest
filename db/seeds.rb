# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

j = Contestant.create({ first_name: 'Jason', email: 'jason@somemail.com', password: 'monkey' })
k = Contestant.create({ first_name: 'Kat',   email: 'kat@catmail.com', password: 'pony'})

a = Photo.create!({
    title:      'Moon at night',
    category:    'landscapes',
    tags:       ['moon', 'night', 'ET'],
    owner:      j
})
b = Photo.create!({
    title:      'Trees in park',
    category:   'flora',
    tags:       ['trees'],
    owner:      k
})

b.comments.create name: 'Jason', text: 'Trees need more squirrels!'
a.comments.create name: 'Kat',   text: 'Photoshopped?'

j.favourite_photo a
j.favourite_photo b
k.favourite_photo b