Factory.sequence :username do |n|
  "user#{n}"
end

Factory.sequence :email do |n|
  "email#{n}@test.com"
end

Factory.define(:question) do |q|
  q.content   "Where can I find a good churro?"
end

Factory.define(:user) do |u|
  u.email                 Factory.next :email
  u.username              Factory.next :username
  u.password              "password"
  u.password_confirmation "password"
end