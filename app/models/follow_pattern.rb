class FollowPattern < ActiveRecord::Base
  PATTERN_REGEX = /\[([^\]]+)\]/

  class << self
    def hint_from(pattern)
      pattern.split(/[\[\]]/, -1).each_with_index.map{|part, index|
        index % 2 == 1 ? part : part.split(/\s/, -1).map{ |sub_part| '*' * sub_part.size }.join(' ')
      }.join("")
    end

    def answer_from(pattern)
      pattern.gsub(PATTERN_REGEX){ |chars|chars[1..-2] }
    end
  end

  def hint
    FollowPattern.hint_from(self.pattern)
  end

  def answer
    FollowPattern.answer_from(self.pattern)
  end

  def question
    Question.find_by_data_id_and_data_type(id, FollowPattern.name)
  end

  def realized_answer(user_answer)
    user_answer
  end

  def preview
    self.instruction
  end

  def score_for(user_answer)
    user_answer.try(:downcase) == answer.try(:downcase) ? 1 : 0
  end
end
