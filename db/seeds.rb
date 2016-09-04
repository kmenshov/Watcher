# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(email: 'admin@example.com', password: 'admin3573', password_confirmation: 'admin3573')

group = ResGroup.new(name: Rails.configuration.res_group_reserved_names[0], user_id: user.id)
group.save(validate: false)