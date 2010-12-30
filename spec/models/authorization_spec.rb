require 'spec_helper'

describe Authorization do
  describe "relationships" do
    it {should belong_to(:user)}
  end
end
