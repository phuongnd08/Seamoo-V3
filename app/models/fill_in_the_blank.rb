class FillInTheBlank < ActiveRecord::Base
  def answer
    answer_parts.join(", ")
  end

  def segments
    index = 0
    @segments ||= content.split(/[\{\}]/).map{|chunk|
      index +=1
      index % 2 == 1 ? text_segment(chunk) : input_segment(chunk)
    }
  end

  def preview
    segments.map{|segment|
      segment[:type] == "text" ? segment[:text] : "(#{segment[:hint]})"
    }.join("")
  end

  def realized_answer(answer)
    answer
  end

  def score_for(user_answer)
    if user_answer.present?
      user_parts = user_answer.split(/,\s?/, -1)
      parts = answer_parts
      if (user_parts.size == parts.size)
        index = -1
        user_parts.count{|p| p.downcase == parts[index+=1].downcase} * 1.0 / parts.size
      else; 0; end
    else; 0; end
  end

  private
  def text_segment(text)
    {:type => "text", :text => text}
  end

  def input_segment(chunk)
    if chunk.include?("|")
      parts = chunk.split("|")
      {:hint => parts.first, :no_highlight => true, :answer => parts.last}
    else
      parts = chunk.split(/[\[\]]/)
      index = 0
      {
        :hint => parts.map{|p|
          index +=1
          index % 2 == 1 ? '*' * p.length : p
        }.join(""),
        :answer => parts.join("")
      }
    end.merge(:type => "input")
  end

  def answer_parts
    segments.select{|s| s[:type] == "input"}.map{|segment|segment[:answer]}
  end

end
