require 'spec_helper'

describe Contest do
  describe "state transitions" do 

    context "when new" do 
      it "contests are in configuration state" do 
        expect(Contest.new.state_name).to eql :configuration
      end

      xit "does not transition to another state" do 

      end
    end

    context "when configured" do 
      before :each do
        @contest = build :configured_contest
      end

      xit "transitions to another state" do 
      end
    end
  end

  describe "#configured?" do 
    it "is false when all variables are not set" do 
      expect(Contest.new.configured?).to be false
    end

    it "is true when all variables are set" do 
      expect(build(:configured_contest).configured?).to be true
    end
  end
end