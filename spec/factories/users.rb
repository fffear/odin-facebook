FactoryBot.define do
  factory :user do
    email { "testemail@example.com" }
    password { 'password' }

    factory :invalid_user do
      email { "" }
      password { "" }
    end
  end
end
