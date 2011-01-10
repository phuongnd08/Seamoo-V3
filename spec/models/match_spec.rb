require 'spec_helper'

describe Match do
  describe "relationships" do
    it {should have_many(:questions)}
    it {should have_many(:users)}
  end
end
