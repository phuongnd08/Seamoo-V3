class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :league
  before_save :calculate_rank_score
  cattr_accessor :per_page
  @@per_page = DisplaySettings.memberships_per_page

  def add_match_score(score)
    self.update_attributes(:matches_score => self.matches_score + score, :matches_count => self.matches_count + 1)
  end

  protected
  def calculate_rank_score
    self.rank_score = if self.matches_score > 0 
                        self.matches_score / Math.sqrt(self.matches_count)
                      else
                        0
                      end
  end
end
