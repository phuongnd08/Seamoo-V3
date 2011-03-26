require 'spec_helper'

describe Authorization do
  describe "relationships" do
    it {should belong_to(:user)}
  end

    describe "omniauth" do
      it "should be persisted as serialized form" do
        auth = Factory(:authorization)
        auth.update_attribute(:omniauth, {"a" => "b"})
        auth.reload.omniauth.should == {"a" => "b"}
      end
    end
end
