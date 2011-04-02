Factory.define :category do |c|
  c.sequence(:name) {|n| "Category #{n}"}
  c.sequence(:image) {|n| "categories/#{n}.png"}
end

Factory.define :category_with_questions, :parent => :category do |c|
  c.questions { |qs| [qs.association(:question, :level => 0), qs.association(:question, :level => 0), qs.association(:question, :level => 0)] }
end

Factory.define :active_category, :parent => :category do |s|
  s.status 'active'
end

Factory.define :coming_soon_category, :parent => :category do |s|
  s.status 'coming_soon'
end
