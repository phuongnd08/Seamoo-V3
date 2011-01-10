class MatchQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :match
end
