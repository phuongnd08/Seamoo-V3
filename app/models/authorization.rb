class Authorization < ActiveRecord::Base
  belongs_to :user
  # validates :user, :presence => true
  validates :uid, :uniqueness => {:scope => :provider}
end
