# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

yields_list = [
  [ "Content 1", 0 ],
  [ "Content 2", 1 ],
  [ "Content 3", 2 ],
  [ "Content 4", 3 ],
  [ "Content 5", 4 ],
  [ "Content 6", 4 ],
  [ "Content 7", 3 ],
  [ "Content 8", 2 ],
  [ "Content 9", 1 ],
  [ "Content 10", 0 ],
  [ "Content 11", 1 ],
  [ "Content 12", 0 ],
  [ "Content 13", 1 ]
]

ress = Recipe.all

yields_list.each do |content, res_n|
  ResYield.create( content: content, read: false, recipe: ress[res_n] )
end