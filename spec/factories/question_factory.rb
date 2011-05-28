Factory.define :question do |q|
  q.association(:data, :factory => :multiple_choice)
end

Factory.define :question_with_image, :class => Question do |q|
  q.association(:data, :factory => :multiple_choice_with_image)
end

Factory.define :fill_in_the_blank_question, :class => Question do |q|
  q.association(:data, :factory => :fill_in_the_blank)
end

Factory.define :multiple_choice do |m|
  m.sequence(:content) {|n| "Multiple choice \##{n}"}
  m.options { |os| [
    os.association(:multiple_choice_option, :content => "Option #a", :correct => true), 
    os.association(:multiple_choice_option, :content => "Option #b")
  ] }
end

Factory.define :multiple_choice_with_image, :parent => :multiple_choice do |m|
  m.sequence(:content) {|n| "Multiple choice \##{n}: <img src='/images/logo.png'/>"}
end

Factory.define :multiple_choice_option do |o|
end

Factory.define :fill_in_the_blank do |f|
  f.content("This is {blank1} and {blank2}")
end

