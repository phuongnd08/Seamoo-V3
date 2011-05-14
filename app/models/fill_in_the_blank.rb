class FillInTheBlank < ActiveRecord::Base
  def answer
    segments.select{|s| s[:type] == "input"}.map{|segment|segment[:answer]}.join(", ")
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

end
