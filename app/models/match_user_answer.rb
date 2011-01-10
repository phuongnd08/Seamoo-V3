class MatchUserAnswer < ActiveRecord::Base
  belongs_to :match_user
  belongs_to :match_question
end
