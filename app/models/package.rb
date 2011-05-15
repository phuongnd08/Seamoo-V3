class Package < ActiveRecord::Base
  serialize :entries
  belongs_to :category
  
  def import
    error = ""
    pos = 0
    self.entries = []
    File.open(path){|f| f.readlines }.each do |line|
      pos += 1
      question = create_question_from_line(line.squish)
      unless question.nil?
        self.entries << question.id
      else
        error << "#{path}:#{pos} - Invalid data line\n"
      end
    end
    self.done = true
    self.save!
    raise error unless error.blank?
  end

  def create_question_from_line(line)
    extra = {:category => category, :level => level}
    if line =~ /\{[\w\s\[\|]+\}/
        Question.create_fill_in_the_blank(line, extra)
    else
      parts = line.split("|")
      if (parts.length > 2)
        options_hash = MultipleChoice.array_to_options_hash(parts[1..-1])
        Question.create_multiple_choices(parts[0], options_hash, extra)
      elsif parts.length == 2
        pattern = parts[1]
        pattern = pattern[1..-1] if pattern.start_with?("*")
        Question.create_follow_pattern(parts[0], pattern, extra)
      else
        nil
      end
    end
  end

  def unimport!
    self.entries.each do |e|
      q = Question.find_by_id(e)
      q.destroy if q
    end
    self.destroy
  end
end
