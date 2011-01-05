class MultipleChoice < ActiveRecord::Base
  has_many :options, :class_name => 'MultipleChoiceOption', :foreign_key => :parent_id, :dependent => :destroy
end
