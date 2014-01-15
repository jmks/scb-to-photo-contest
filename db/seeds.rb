# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

j = Contestant.create({ first_name: 'Jason', id: 'jason@somemail.com' })
k = Contestant.create({ first_name: 'Kat',   id: 'kat@catmail.com'})

a = Photo.create({
    title:      'Moon at night',
    tags:       ['moon', 'night', 'ET']
})
b = Photo.create({
    title:      'Trees in park',
    tags:       ['trees']
})

b.comments.create name: 'Jason', comment: 'Trees need more squirrels!'
a.comments.create name: 'Kat',   comment: 'Photoshopped?'

j.entries << a
k.entries << b

j.favourites << a
j.favourites << b
k.favourites << b