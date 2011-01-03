class User < ActiveRecord::Base
  acts_as_authentic do |c|
  end

  has_many :authorizations
  
  def self.create_from_omni_info(user_info)
    User.create!(
      :display_name => user_info['name'],
      :email => user_info['email']
    )
  end
end
