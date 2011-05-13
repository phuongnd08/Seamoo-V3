class FillInTheBlank < ActiveRecord::Base
  def answer
    segments.select{|s| s[:type] == "input"}.map{|segment|segment[:answer]}.join(", ")
  end

  def parts
    segments.map{|segment|
      segment[:type] == "hint" ? segment : segment.dup.delete_if{|key, value| key == :answer}
    }
  end

  def preview
    segments.map{|segment|
      segment[:type] == "hint" ? segment[:text] : "(#{segment[:pattern]})"
    }.join("")
  end

  private
  def hint_segment(text)
    {:type => "hint", :text => text}
  end

  def input_segment(chunk)
    if chunk.include?("|")
      parts = chunk.split("|")
      {:pattern => parts.first, :highlight_as_typing => false, :answer => parts.last}
    else
      parts = chunk.split(/[\[\]]/)
      index = 0
      {
        :pattern => parts.map{|p|
          index +=1
          index % 2 == 1 ? '*' * p.length : p
        }.join(""),
        :answer => parts.join("")
      }
    end.merge(:type => "input")
  end

  def segments
    index = 0
    content.split(/[\{\}]/).map{|chunk|
      index +=1
      index % 2 == 1 ? hint_segment(chunk) : input_segment(chunk)
    }
  end
end
