class Question < ActiveRecord::Base
  belongs_to :category
  belongs_to :creator, :class_name => User.name
  belongs_to :data, :polymorphic => true, :dependent => :destroy

  class << self
    def create_multiple_choices(content, options_hash, extra = {})
      data = MultipleChoice.create(:content => content)
      options_hash.keys.each{|key|
        data.options.create(:content => key, :correct => options_hash[key])
      }
      create(extra.merge(:data => data))
    end

    def create_follow_pattern(instruction, pattern, extra = {})
      data = FollowPattern.create(:instruction => instruction, :pattern => pattern)
      create(extra.merge(:data => data))
    end

    def create_fill_in_blank(content, extra = {})
      data = FillInTheBlank.create(:content => content)
      create(extra.merge(:data => data))
    end
  end

  def content
    if data.is_a?(MultipleChoice)
      data.content
    else
      data.instruction
    end
  end
end
