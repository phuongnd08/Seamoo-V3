class User < ActiveRecord::Base
  require 'digest/md5'
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

  def membership_in(league)
    Membership.find_or_create_by_league_id_and_user_id(:league_id => league.id, :user_id => self.id)
  end

  def qualified_for?(league)
    unless league.level == 0 
      league.previous.all?{|l| membership_in(l).rank_score >= Matching.qualified_rank_score}
    else
      true
    end
  end

  def email_hash
    Digest::MD5.hexdigest(self.email)
  end
end
