require 'spec_helper'

describe MultipleChoice do
  describe "relationship" do
    it {should have_many(:options)}
  end
end
