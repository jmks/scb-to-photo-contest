require 'spec_helper'

describe Contest do
  let(:past_contest) { create :past_contest }
  let(:open_contest) { create :contest }

  describe "self.any?" do
    context "when default date used" do
      it "returns false if no open contests" do
        past_contest
        expect(Contest.any?).to be false
      end

      it "returns true with an open contest" do
        open_contest
        expect(Contest.any?).to be true
      end
    end

    context "when querying by date" do
      it "returns false if no contest open on date" do
        open_contest
        expect(Contest.any?(open_contest.open_date - 1.day)).to be false
      end

      it "returns true if a contest was open on that date" do
        past_contest
        expect(Contest.any?(past_contest.open_date + 1.day)).to be true
      end
    end
  end

  describe "self.current" do
    context "when no current open contest" do
      it "returns nil" do
        expect(Contest.current).to be nil
      end
    end

    context "when there is an open contest" do
      it "returns that contest" do
        open_contest
        expect(Contest.current).to eql open_contest
      end
    end
  end

  describe "validate :dates_validation" do
    it "requires opening date to be before closing date" do
      contest = Contest.new(open_date: 1.day.ago, close_date: 2.days.ago)

      expect(contest).to_not be_valid
      expect(contest.errors[:open_date]).to be_present
    end

    it "requires judging opening date to be before judging closing date" do
      contest = Contest.new(judge_open_date: 1.day.ago, judge_close_date: 2.days.ago)

      expect(contest).to_not be_valid
      expect(contest.errors[:judge_open_date]).to be_present
    end

    it "requires opening date to be before voting closing date" do
      contest = Contest.new(open_date: 1.day.ago, voting_close_date: 2.days.ago)

      expect(contest).to_not be_valid
      expect(contest.errors[:open_date]).to be_present
    end
  end

  describe "#open?" do
    context "when contest is open" do
      it "returns true" do
        expect(open_contest).to be_open
      end
    end

    context "when contest is not open" do
      it "returns false" do
        expect(past_contest).to_not be_open
      end
    end
  end

  describe "#judging?" do
    context "when contest can be judged" do
      it "returns true" do
        Timecop.freeze(open_contest.judge_open_date + 1.hour)

        expect(open_contest).to be_judging
      end
    end

    context "when contest can not be judged" do
      it "returns false" do
        expect(open_contest).to_not be_judging
      end
    end
  end

  describe "#voting?" do
    context "when voting can occur" do
      it "returns true" do
        expect(open_contest).to be_voting
      end
    end

    context "when voting can not occur" do
      it "returns false" do
        Timecop.freeze(open_contest.voting_close_date)

        expect(open_contest).to_not be_voting
      end
    end
  end
end
