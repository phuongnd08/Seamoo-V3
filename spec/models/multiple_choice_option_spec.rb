require 'spec_helper'

describe MultipleChoiceOption do
  describe "relationship" do
    it {should belong_to(:parent)}
  end
end
