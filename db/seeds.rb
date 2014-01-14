# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

j = Contestant.create({ first_name: "Jason", id: "jason@somemail.com" })
k = Contestant.create({ first_name: "Kat",   id: "kat@catmail.com"})

# Photo.create([
#   {
#     title:      "Moon at night",
#     contestant: j,
#     tags:       ["moon", "night", "ET"]
#   },
#   {
#     title:      "Trees in park",
#     contestant: k,
#     tags:       ['trees']
#   }
# ])

# why isn't contestant saved here?
a = Photo.create({
    title:      "Moon at night",
    contestant: j,
    tags:       ["moon", "night", "ET"]
  })

b = Photo.create([
  {
    title:      "Trees in park",
    contestant: k,
    tags:       ['trees']
  }])