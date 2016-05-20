# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(
	username: "jia96",
  email: "akashahikari@gmail.com",
  password: "password",
  password_confirmation: "password",
  admin: true
  )

User.create(
	username: "yimin",
  email: "yimin@kouhaidash.org",
  password: "password",
  password_confirmation: "password"
  )

10.times do |n|
  username =""
  until username.length >= 4
    username = Faker::Internet.user_name[0...16]
  end
  email = "#{n+1}@kouhaidash.org"
  password = "password"
  User.create(
  	username: username,
    email: email,
    password: password,
    password_confirmation: password
    )
end

Group.create(name: 'TestGroup')
Group.create(name: 'NoMember')
5.times do |i|
  Membership.create(user_id: i, group_id:1)
end

5.times do |i|
  Category.create(name: ["Cat",i.to_s].join, group_id: 1, type_no: i, public: true)
end
