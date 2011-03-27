class User < ActiveRecord::Base
  include Gravtastic
  gravtastic :default => Styling.default_gravatar
  acts_as_authentic
  validates :display_name, :presence => true
  validates :email, :presence => true

  has_many :authorizations, :dependent => :destroy
  has_many :links, :dependent => :destroy
  has_many :memberships, :dependent => :destroy

  def self.create_from_omni_info(user_info)
    user = User.create(
      :display_name => user_info['name'],
      :email => user_info['email'],
      :date_of_birth => user_info['birthday']
    )

    if user_info.has_key?("urls")
      user_info["urls"].each do |name, url|
        user.links << Link.new(:name => name, :url => url) if url.present?
      end
    end

    user
  end

  def age
    Time.now.year - self.date_of_birth.year
  end
end
