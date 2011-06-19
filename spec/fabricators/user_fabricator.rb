Fabricator(:user) do
  email                 { sequence(:email) {|i| "email#{i}@test.com"} }
  username              { sequence(:username) {|i| "user#{i}"} }
  password              "password"
  password_confirmation "password"
end