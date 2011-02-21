class FollowPattern < ActiveRecord::Base
  def hint
    pattern.gsub(/\[([^\]]+)\]/){ |chars|'*'*(chars.size - 2) }
  end

  def question
    Question.find_by_data_id_and_data_type(id, FollowPattern.name)
  end

  def realized_answer(user_answer)
    user_answer
  end
end
