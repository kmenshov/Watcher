# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

yields_list = [
  [ "Germany", 0 ],
  [ "France", 0 ],
  [ "Belgium", 1 ],
  [ "Netherlands", 1 ]
]

ress = Recipe.all

yields_list.each do |content, res_n|
  ResYield.create( content: content, read: false, recipe: ress[res_n] )
end