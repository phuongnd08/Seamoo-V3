class Authorization < ActiveRecord::Base
  belongs_to :user
  serialize :omniauth
  # validates :user, :presence => true
  validates :uid, :uniqueness => {:scope => :provider}

end
