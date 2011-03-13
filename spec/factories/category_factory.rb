Factory.define :category do |s|
  s.sequence(:name) {|n| "Category #{n}"}
end

Factory.define :active_category, :parent => :category do |s|
  s.status 'active'
end

Factory.define :coming_soon_category, :parent => :category do |s|
  s.status 'coming_soon'
end
