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
  password = Faker::Internet.password(8)
  User.create(
  	username: username,
    email: Faker::Internet.email[0...64],
    password: password,
    password_confirmation: password
    )
end

magic_number.times do |n|
  organisation = "#{Faker::Company.name} #{Faker::Company.suffix}"
  Contact.create(
    name: Faker::Name.name[0...64],
    organisation: organisation,
    position: Faker::Company.profession,
    email: Faker::Internet.email[0...64],
    phone: Faker::PhoneNumber.cell_phone,
    website: Faker::Internet.url,
    description: Faker::Lorem.paragraph
  )
end

Group.create(name: 'TestGroup')
Group.create(name: 'NoMember')
Group.create(name: 'Not Approved')
magic_number.times do |i|
  Membership.create(user_id: i+1, group_id:1, approved: (i!=0 && i%2==0? false : true))
end
Membership.create(user_id: 1, group_id:3, approved: false)
Membership.create(user_id: 2, group_id:3, approved: false)
Category.create(name: "Private Task List", group_id: 1, type_no: 3, is_public: false)
Category.create(name: "Public Task List", group_id: 1, type_no: 3, is_public: true)
magic_number.times do |i|
  probably = i % 2
  Task.create(
    category_id: 1+i%2,
    name: "Complete KouhaiDash!",
    description: "Need to settle the login system asap!",
    deadline: Date.new(2016, 12, 25),
    done: probably
    )
    2.times do |j|
      TaskAssignment.create(
        task_id: i+1,
        membership_id: (13*i+7*j)%10+1
      )
    end
end

# id: nil, name: nil, deadline: nil, description: nil, done: nil,
# created_at: nil, updated_at: nil, category_id: nil
