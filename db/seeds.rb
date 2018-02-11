User.create!(name:"Samer Mohamed", email:"samirsuraj@live.com",
             password:"windows", password_confirmation:"windows",
             admin: true, activated:true, activated_at:Time.zone.now)
99.times do |n|
  name=Faker::Name.name
  email="example#{n+1}@sth.com"
  User.create!(name:name, email:email,
               password:"password", password_confirmation:"password"
               activated:true, activated_at:Time.now)
end
