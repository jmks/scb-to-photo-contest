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

    describe "#open_contest" do
      before :each do 
        @contest = build :configured_contest
      end

      it "opens the contest from closed" do
        @contest.finalize_configuration

        @contest.open_contest

        expect(@contest.state_name).to eql :open
      end

      it "fails for other states" do 
        @contest.open_contest

        expect(@contest.state_name).to_not eql :open
      end
    end

    describe "#close_contest" do
      before :each do 
        @contest = build :running_contest
      end

      it "closes the contest" do
        @contest.close_contest

        expect(@contest.state_name).to eql :closed
      end
    end

    describe "#assign_prizes" do
      before :each do 
        @contest = build :configured_contest
      end

      it "changes state" do
        @contest.assign_prizes

        expect(@contest.state_name).to eql :prize_assignment
      end
    end

    describe "#finalize_contest" do
      before :each do 
        @contest = build :configured_contest
      end

      it "completes the contest" do
        @contest.finalize_contest

        expect(@contest.state_name).to eql :complete
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

      it "when dates do not make sense" do 
        contest = build :configured_contest
        contest.open_date  = 1.day.ago
        contest.close_date = 2.days.ago

        expect(contest).to_not be_configured
      end
    end

    it "is true when all variables are set and are valid" do 
      expect(build(:configured_contest).configured?).to be true
    end
  end


end