require 'spec_helper'

describe Question do
  describe "relationship" do
    it {should belong_to(:subject)}
    it {should belong_to(:creator)}
    it {should belong_to(:data)}
  end
end
