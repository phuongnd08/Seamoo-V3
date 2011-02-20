class MatchUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :match
  serialize :answers
  after_save :request_match_check

  def add_answer(index, answer)
    self.answers ||= {}
    self.answers[index] = answer
    self.current_question_position= index + 1
    self.finished_at = Time.now if (current_question_position== match.questions.size)
  end

  def finished?
    finished_at.present?
  end

  def current_question
    match.questions[current_question_position]
  end

  protected
  def current_question_position=(question_position)
    super(question_position)
  end

  def request_match_check
    self.match.check_if_finished! if self.finished?
  end
end
