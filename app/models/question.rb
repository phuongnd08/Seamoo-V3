class Question < ActiveRecord::Base
  belongs_to :subject
  belongs_to :creator, :class_name => User.name
  belongs_to :data, :polymorphic => true
end
