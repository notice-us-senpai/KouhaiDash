# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

magic_number = 10

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

magic_number.times do |n|
  username = ""
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

Contact.create(
  name: "Chia Hui",  
  organisation: "NUS", 
  position: "Sophomore", 
  email: "ch@u.nus.edu", 
  number: 87654321, 
  website: "chia-hui.azurewebsites.net", 
  description: "Our awesome friend."
  )

magic_number.times do |n|
  name = ""
  until name.length >= 2
    name = Faker::Internet.name[0...64]
  end
  Contact.create(
    name: name, 
    organisation: "{n+1} KouhaiDash Pte Ltd", 
    position: "CTO", 
    email: "#{name}@kouhaidash.org", 
    number: "87654321", 
    website: "#{name}.azurewebsites.net", 
    description: "Our BFF"
  )
end


# <<<<<<< HEAD
# =======
=begin

>>>>>>> delete-user
Group.create(name: 'TestGroup')
Group.create(name: 'NoMember')
magic_number.times do |i|
  Membership.create(user_id: i, group_id:1)
end

magic_number.times do |i|
  Category.create(name: ["Cat",i.to_s].join, group_id: 1, type_no: i, public: true)
end

magic_number.times do |i|
  probably = i % 2
  Task.create(
    category_id: i,
    name: "Complete KouhaiDash!",
    description: "Need to settle the login system asap!",
    deadline: Date.new(2016, 12, 25),
    done: probably
    )
end

# id: nil, name: nil, deadline: nil, description: nil, done: nil, 
# created_at: nil, updated_at: nil, category_id: nil
<<<<<<< HEAD
=======

=end
# >>>>>>> delete-user
