Fabricator(:user) do
  email                 { sequence(:email) {|i| "email#{i}@test.com"} }
  user_name             { sequence(:user_name) {|i| "user#{i}"} }
  password              "password"
  password_confirmation "password"
end