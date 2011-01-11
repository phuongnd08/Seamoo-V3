Factory.define :user do |u|
  u.sequence(:email) {|n| "user#{n}@email.com"}
end