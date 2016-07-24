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
  user=false
  until user
    username = ""
    until username.length >= 4
      username = Faker::Internet.user_name(%w(_ -))[0...16]
    end
    password = Faker::Internet.password(8)
    user=User.create(
    	username: username,
      email: Faker::Internet.email[0...64],
      password: password,
      password_confirmation: password
    ).id
  end
end

Group.create(name: 'EGroup', string_id: 'EGroup', description: 'This is an example group. Take a look to see how this website can be used.')
Group.create(name: 'NoMember', string_id: 'nomember')
Group.create(name: 'Not Approved', string_id: 'notapproved')
magic_number.times do |i|
  Membership.create(user_id: i+1, group_id:1, approved: (i!=0 && i%2==0? false : true))
end
Membership.create(user_id: 1, group_id:3, approved: false)
Membership.create(user_id: 2, group_id:3, approved: false)
Category.create(name: "Welcome", group_id: 1, type_no: 2, is_public: true)
Category.create(name: "Private Task List", group_id: 1, type_no: 3, is_public: false)
Category.create(name: "Public Task List", group_id: 1, type_no: 3, is_public: true)
Category.create(name: "Contacts", group_id: 1, type_no: 1, is_public: true)
Category.create(name: "Events", group_id: 1, type_no: 0, is_public: true)

TextPage.create(title: "EGroup", contents: "This is an example group. Take a look to see how this website can be used.", category_id: '1')

magic_number.times do |i|
  Task.create(
    category_id: 2+Faker::Number.between(1, 10)%2,
    name: Faker::Hacker.verb() + " "+Faker::Hacker.adjective() +" "+ Faker::Hacker.noun() ,
    description: Faker::Lorem.paragraph,
    deadline: Faker::Date.between(5.year.ago, 5.year.from_now),
    done: Faker::Boolean.boolean
    )
    Faker::Number.between(1, 3).times do |j|
      TaskAssignment.create(
        task_id: i+1,
        membership_id: Faker::Number.between(1, 10)%10+1
      )
    end
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
    description: Faker::Lorem.paragraph,
    category_id: 4
  )
end
Calendar.create(category_id: 5, time_zone: 'Singapore')
magic_number.times do |n|
  start_date= Faker::Time.forward(60, :all)
  end_date = Faker::Time.between(start_date, start_date+3.days)

  Event.create(calendar_id: 1,
    summary: Faker::Company.buzzword()+' discussion',
    start: start_date.to_datetime,
    end: end_date.to_datetime,
    location: Faker::Company.name() +" room",
    description: Faker::Company.bs
  )
end

magic_number.times do |i|
  name=Faker::Team.name
  group=Group.create(name: Faker::Team.name,
    string_id: Faker::Internet.user_name(name, %w(_ -)),
    description: Faker::StarWars.quote
  )
  Membership.create(user_id: 1, group_id:group.id, approved: true)
  Membership.create(user_id: 2, group_id:group.id, approved: true)
  no=Faker::Number.between(1, 5)
  no.times do |n|
    Membership.create(user_id: Faker::Number.between(3, 13), group_id:group.id, approved:Faker::Boolean.boolean)
  end
end

# id: nil, name: nil, deadline: nil, description: nil, done: nil,
# created_at: nil, updated_at: nil, category_id: nil
