class MatchUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :match
  serialize :answers
  after_initialize :set_default_answers
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

  def score
    value = super
    if value.nil?
      value = self.score = (0...match.questions.size).map do |index|
        match.questions[index].data.score_for(answers[index])
      end.sum
      self.save
    end
    value
  end

  def score_as_percent
    (score * 100.0 / match.questions.size).round
  end

  protected
  def current_question_position=(question_position)
    super(question_position)
  end

  def set_default_answers
    self.answers ||= {}
  end

  def request_match_check
    self.match.check_if_finished! if self.finished?
  end
end
