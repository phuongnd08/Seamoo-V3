Factory.define :league do |l|
  l.association(:category)
  l.sequence(:name) {|n| "League #{n}"}
end
