require 'spec_helper'

describe Contest do
  describe "state transitions" do 

    context "when new" do 
      before :each do 
        @contest = Contest.new
      end

      it "contests are in configuration state" do 
        expect(@contest.state_name).to eql :configuration
      end

      it "does not transition to another state" do 
        @contest.finalize_configuration

        expect(@contest.state_name).to eql :configuration
      end
    end

    context "when configured" do 
      before :each do
        @contest = build :configured_contest
      end

      it "transitions to another state" do 
        @contest.finalize_configuration

        expect(@contest.state_name).to eql :closed
      end
    end
  end

  describe "#configured?" do 
    context "is false" do 
      it "when new" do 
        expect(Contest.new.configured?).to be false
      end

      it "when all variables are not set" do 
        contest = Contest.new
        contest.open_date = 1.day.ago

        expect(contest).to_not be_configured
      end
    end

    it "is true when all variables are set" do 
      expect(build(:configured_contest).configured?).to be true
    end
  end
end