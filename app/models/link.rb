class Link < ActiveRecord::Base
  belongs_to :user
  validates :name, :uniqueness => { :scope => :user_id }
end
