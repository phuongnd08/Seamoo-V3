class MatchRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :league
  belongs_to :match
end
