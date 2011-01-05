class Question < ActiveRecord::Base
  belongs_to :category
  belongs_to :creator, :class_name => User.name
  belongs_to :data, :polymorphic => true, :dependent => :destroy

  class << self
    def create_multiple_choices(content, options_hash)
      data = MultipleChoice.create(:content => content)
      options_hash.keys.each{|key|
        data.options.create(:content => key, :correct => options_hash[key])
      }
      create(:data => data)
    end

    def create_follow_pattern(instruction, pattern)
      data = FollowPattern.create(:instruction => instruction, :pattern => pattern)
      create(:data => data)
    end
  end
end
