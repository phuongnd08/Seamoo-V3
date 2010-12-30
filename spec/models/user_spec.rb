require 'spec_helper'

describe User do
  describe "relationships" do
    it{should have_many(:authorizations)}
  end
end
