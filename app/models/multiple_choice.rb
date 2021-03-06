class MultipleChoice < ActiveRecord::Base
  has_many :options, :class_name => 'MultipleChoiceOption', :foreign_key => :parent_id, :dependent => :destroy
  accepts_nested_attributes_for :options, :allow_destroy => true

  def question
    Question.find_by_data_id_and_data_type(id, MultipleChoice.name)
  end

  def randomized_options
    (0...options.size).to_a.shuffle.map{|index| [index, options[index]]}
  end

  def realized_answer(user_answer)
    user_answer.blank? ? nil : options[user_answer.to_i].content
  end

  def preview
    self.content
  end

  def answer
    options.detect{|o| o.correct}.content
  rescue => e
    HoptoadNotifier.notify(
      :error_class   => "MultipleChoice",
      :error_message => "Exception while call #answer: #{e.message}",
      :parameters    => {:multiple_choice_id => self.id}
    )
    nil
  end

  def score_for(answer)
    if answer.present?
      options[answer.to_i].correct ? 1 : 0
    else; 0; end
  end

  class << self
    def string_to_options_hash(str)
      array_to_options_hash(str.split("|"))
    end

    def array_to_options_hash(arr)
      arr.inject({}) do |r, o|
        if o.start_with?('*')
          r[o[1..-1]]=true
        else
          r[o]=false
        end
        r
      end
    end
  end
end
