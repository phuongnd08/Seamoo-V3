Factory.define :user do |u|
  u.sequence(:email) {|n| "user#{n}@email.com"}
  u.sequence(:display_name) {|n| "user#{n}"}
  u.authorizations { |as| [as.association(:authorization)] }
  u.date_of_birth 20.years.ago
end

Factory.define :bot do |u|
  u.sequence(:email) {|n| "bot#{n}@email.com"}
  u.sequence(:display_name) {|n| "bot#{n}"}
end

Factory.define :authorization do |a|
  a.sequence(:uid) {|n| "http://openid.net/?id=#{n}" }
  a.provider "open_id"
end
