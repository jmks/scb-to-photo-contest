# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

contest = Contest.create!({
  open_date:  1.day.ago,
  close_date: 6.days.from_now,
  judge_open_date: 1.week.from_now,
  judge_close_date: 2.weeks.from_now,
  voting_close_date: 1.week.from_now,
  votes_per_day: 3,
  entries_per_contestant: 5
})

j = Contestant.create!({
    first_name:   'Jason',
    last_name:    'Schweier',
    public_name:  'Squirrel Charmer',
    email:        'jason@somemail.com',
    password:     'monkey123',
    admin:        true
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

Tag.add_tags([
    'meadow',
    'mountain',
    'field',
    'grassland',
    'farm',
    'lake',
    'river',
    'ravine',
    'stream',
    'ocean',
    'beach',
    'forest',
    'desert',
    'tundra',
    'ice',
    'sunset',
    'cloud',
    'sky',
    'rocks',
    'hedgerow',
    'garden',
    'spring',
    'summer',
    'fall',
    'winter',
    'snow',
    'rain',
    'echinoderm',
    'shark',
    'fish',
    'amphibian',
    'reptile',
    'bird',
    'marsupial',
    'mammal',
    'virus',
    'bacteria',
    'protist',
    'sponge',
    'coral',
    'jellyfish',
    'nematode',
    'flatworm',
    'rotifer',
    'molluscs',
    'annelid',
    'centipede',
    'crustacean',
    'spider',
    'insect',
    'butterfly',
    'fly',
    'dragonfly',
    'beetle',
    'pollinator',
    'bee',
    'wasp',
    'fungus',
    'algae',
    'lichen',
    'liverwort',
    'hornwort',
    'bryophyte',
    'lycophyte',
    'moss',
    'fern',
    'grass',
    'tree',
    'shrub',
    'herb',
    'wildflower',
    'conifer',
    'Canada',
    'Ontario',
    'Toronto',
    'GTA',
    'Humber River',
    'Rouge River',
    'Don River',
    'Lake Simcoe',
    'Lake Ontario',
    'Rouge Park',
    'High Park',
    'Algonquin Park',
    'species at risk',
    'endangered species',
    'Oak Ridges Morraine',
    'Green Belt',
    'Niagara Escarpment',
    'Georgian Bay'
])
