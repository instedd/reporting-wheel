require 'machinist/active_record'

require 'sham'
require 'faker'

Sham.define do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  username { Faker::Internet.user_name }
  url { Faker::Internet.domain_name }
  password { Faker::Name.name }
  phone_number { Faker::PhoneNumber::phone_number }
  address { Faker::Address::street_address }
end

User.blueprint do
  username { Sham.username }
  password { Sham.password }
  password_confirmation { password }
end
