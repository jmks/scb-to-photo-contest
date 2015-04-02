require 'spec_helper'

describe ContestRules do 

  before :all do 
    @before = ContestRules::CONTEST_OPENS - 1.day
    @during = ContestRules::CONTEST_OPENS + 1.day
    @after  = ContestRules::CONTEST_CLOSES + 1.day
  end

  describe 'self.contest_open?' do 
    
    it 'is false before contest opens' do 
      expect(ContestRules.contest_open?(@before)).to eql false
    end

    it 'is true on contest opens date' do 
      expect(ContestRules.contest_open?(ContestRules::CONTEST_OPENS)).to eql true
    end

    it 'is true during the contest' do
      expect(ContestRules.contest_open?(@during)).to eql true
    end

    it 'is true day of contest close' do 
      expect(ContestRules.contest_open?(ContestRules::CONTEST_CLOSES)).to eql true
    end
    
    it 'is false after contest closes' do
      expect(ContestRules.contest_open?(@after)).to eql false
    end
  end

  describe 'self.voting_open?' do 

    before :all do 
      @after = ContestRules::JUDGING_CLOSES + 1.days
    end

    it 'is false before contest opens' do 
      expect(ContestRules.voting_open?(@before)).to eql false
    end

    it 'is true on contest opens date' do 
      expect(ContestRules.voting_open?(ContestRules::CONTEST_OPENS)).to eql true
    end

    it 'is true during the contest' do
      expect(ContestRules.voting_open?(@during)).to eql true
    end

    it 'is true after the contest but before judging closes' do 
      expect(ContestRules.voting_open?(ContestRules::CONTEST_CLOSES + 1.days)).to eql true
    end

    it 'is false after the juding closes' do 
      expect(ContestRules.voting_open?(@after)).to eql false
    end
  end
end