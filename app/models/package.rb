class Package < ActiveRecord::Base
  serialize :entries
  belongs_to :category
  
  def import
    error = nil
    pos = 0
    self.entries = []
    File.open(path, "r:utf-8"){|f| f.readlines }.each do |line|
      pos += 1
      parts = line.squish.split("|")
      if (parts.length <= 1)
        error = "#{path}:#{pos} - Invalid data line"
      else
        question = create_question_from_parts(parts)
        self.entries << question.id
      end
    end
    self.done = true
    self.save!
    raise error if error.present?
  end

  def create_question_from_parts(parts)
    question = nil
    if (parts.length == 2)
      pattern = parts[1]
      pattern = pattern[1..-1] if pattern.start_with?("*")
      question = Question.create_follow_pattern(parts[0], pattern)
    else
      options_hash = MultipleChoice.array_to_options_hash(parts[1..-1])
      question = Question.create_multiple_choices(parts[0], options_hash)
    end
    question.update_attributes(:category => category, :level => level)
    question
  end

  def unimport!
    self.entries.each do |e|
      q = Question.find_by_id(e)
      q.destroy if q
    end
    self.destroy
  end
end
