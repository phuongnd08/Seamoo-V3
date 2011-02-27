class FollowPattern < ActiveRecord::Base
  PATTERN_REGEX = /\[([^\]]+)\]/
  def hint
    pattern.gsub(PATTERN_REGEX){ |chars|'*'*(chars.size - 2) }
  end

  def answer
    pattern.gsub(PATTERN_REGEX){ |chars|chars[1..-2] }
  end

  def question
    Question.find_by_data_id_and_data_type(id, FollowPattern.name)
  end

  def realized_answer(user_answer)
    user_answer
  end

  def score_for(user_answer)
    user_answer == answer ? 1 : 0
  end
end
