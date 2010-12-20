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
  username
  password
  password_confirmation { password }
end

Wheel.blueprint do
  name { Sham.username }
  user
  pool
  wheel_rows { 3.times.map {WheelRow.make_unsaved} }
  allow_free_text { false }
end

WheelRow.blueprint do
  label { Sham.username }
  index {1}
  wheel_values { 3.times.map {WheelValue.make_unsaved} }
end

WheelValue.blueprint do
  index {1}
  code {1}
  value { Sham.username }
end

Pool.blueprint do
  name { Sham.username }
  description { Sham.address }
end