class Category < ActiveRecord::Base
  has_many :leagues
  has_many :questions
end
