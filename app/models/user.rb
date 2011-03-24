class User < ActiveRecord::Base
  include Gravtastic
  gravtastic :default => Styling.default_gravatar
  acts_as_authentic
  validates :display_name, :presence => true
  validates :email, :presence => true

  has_many :authorizations, :dependent => :destroy

  def self.create_from_omni_info(user_info)
    User.create!(
      :display_name => user_info['name'],
      :email => user_info['email']
    )
  end

  def age
    Time.now.year - self.date_of_birth.year
  end
end
