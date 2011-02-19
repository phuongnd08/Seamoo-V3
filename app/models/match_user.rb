class MatchUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :match
  serialize :answers

  def add_answer(index, answer)
    self.answers ||= {}
    self.answers[index] = answer
    self.finished_at = Time.now if (index == match.questions.size - 1)
  end

  def finished?
    current_question_position == match.questions.size
  end

  def current_question
    match.questions[current_question_position]
  end
end
