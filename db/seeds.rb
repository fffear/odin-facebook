# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
FriendRequest.delete_all

10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  FactoryBot.create(:user, first_name: first_name, 
                           last_name: last_name,
                           email: "#{(first_name + last_name).downcase}@example.com",
                           password: "password1")
end

(3..10).each do |n|
  FactoryBot.create(:friend_request, requester_id: User.first.id, requestee_id: n)
end


FactoryBot.create(:friendship, requester: User.first, requestee: User.second)