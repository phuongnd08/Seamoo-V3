Factory.define :league do |l|
  l.association(:category)
  l.sequence(:name) {|n| "League #{n}"}
  l.sequence(:image) {|n| "leagues/#{n}.png"}
  l.level 0
end

Factory.define :league_with_questions, :parent => :league do |l|
  l.category { Factory(:category_with_questions) }
end
