class User < ActiveRecord::Base
  include Gravtastic
  gravtastic :default => 'wavatar'
  acts_as_authentic do |c|
  end

  has_many :authorizations, :dependent => :destroy
  
  def self.create_from_omni_info(user_info)
    User.create!(
      :display_name => user_info['name'],
      :email => user_info['email']
    )
  end
end
