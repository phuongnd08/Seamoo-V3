class FollowPattern < ActiveRecord::Base
  def hint
    pattern.gsub(/\[([^\]]+)\]/){ |chars|'*'*(chars.size - 2) }
  end
end
