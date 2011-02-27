Factory.define :user do |u|
  u.sequence(:email) {|n| "user#{n}@email.com"}
end

Factory.define :bot do |u|
  u.sequence(:email) {|n| "bot#{n}@email.com"}
  u.sequence(:display_name) {|n| "bot#{n}"}
end
