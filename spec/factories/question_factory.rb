Factory.define :question do |q|
  q.association(:data, :factory => :multiple_choice)
end

Factory.define :multiple_choice do |m|
  m.sequence(:content) {|n| "Multiple choice \##{n}"}
  m.options { |os| [os.association(:multiple_choice_option, :correct => true), os.association(:multiple_choice_option)] }
end

Factory.define :multiple_choice_option do |o|
  o.sequence(:content) {|n| "Options \##{n}"}
end
