# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

j = Contestant.create!({ 
    first_name:   'Jason',
    last_name:    'Schweier',
    public_name:  'Squirrel Charmer',
    email:        'jason@somemail.com',
    password:     'monkey123'
    })

k = Contestant.create!({
    first_name:    'Kat',
    last_name:     'NotHerName',
    public_name:   'Pony Lady',
    email:         'kat@catmail.com',
    password:      'ponyponypony'
    })

a = Photo.create!({
    title:        'Moon at night',
    category:     :landscapes,
    tags:         ['moon', 'night', 'ET'],
    owner: j
})
b = Photo.create!({
    title:        'Trees in park',
    category:     :flora,
    tags:         ['trees'],
    owner: k
})

b.comments.create name: 'Jason', text: 'Trees need more squirrels!'
a.comments.create name: 'Kat',   text: 'Photoshopped?'