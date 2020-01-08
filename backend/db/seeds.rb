# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.new(first_name: "Dave",
                   last_name: "Johnson",
                   email: "sharknadofan@gmail.com",
                   phone_number: "7176735968",
                   password: "swampthing10",
                   password_confirmation: "swampthing10")


    user[:token] = user.token_gen
    user[:token_expires] = (Time.now + 24*3600*7).to_time

user.save

1000.times do |t|
  pass = Password.new(user_id: user.id, website: "www.website"+t.to_s+".com")
  pass.conceal("password123", "swampthing10")
  pass.save
end
