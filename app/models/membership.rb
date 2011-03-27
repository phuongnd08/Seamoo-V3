class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :league
  before_save :calculate_rank_score

  def record_match_result(score)
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
