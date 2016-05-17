# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(
	username: "jia96",
  email: "akashahikari@gmail.com",
  password: "password",
  password_confirmation: "password"
  )

User.create!(
	username: "yimin",
  email: "yimin@kouhaidash.org",
  password: "password",
  password_confirmation: "password"
  )

10.times do |n|
  username = Faker::Internet.user_name[0...16]
  email = "#{n+1}@kouhaidash.org"
  password = "password"
  User.create!(
  	username: username,
    email: email,
    password: password,
    password_confirmation: password
    )
end
