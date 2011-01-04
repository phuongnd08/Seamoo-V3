class MultipleChoiceOption < ActiveRecord::Base
  belongs_to :parent, :class_name => MultipleChoice.name
end
