require 'spec_helper'

describe Link do
  describe "relationships" do
    it{should belong_to(:user)}
  end
end
