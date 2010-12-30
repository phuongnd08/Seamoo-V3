class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :presence => true
  validates :uid, :uniqueness => {:scope => :provider}
end
