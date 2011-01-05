Factory.define :category do |s|
  s.sequence(:name) {|n| "Category #{n}"}
end