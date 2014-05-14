require 'spec_helper'

describe ContestRules do 

  before :all do 
    @before = DateTime.new(2013, 1, 1)
    @during = ContestRules::CONTEST_OPENS + 1.days
  end

  describe '#contest_open?' do 

    before :all do 
      @after  = ContestRules::CONTEST_CLOSES + 1.days
    end
    
    it 'is false if date is before contest opens' do 
      expect(ContestRules.contest_open?(@before)).to eql false
    end

    it 'is true if date is on contest opens date' do 
      expect(ContestRules.contest_open?(ContestRules::CONTEST_OPENS)).to eql true
    end

    it 'is true if date is during the contest' do
      expect(ContestRules.contest_open?(@during)).to eql true
    end

    it 'is true if date is day of contest close' do 
      expect(ContestRules.contest_open?(DateTime.new(2014, 5, 14))).to eql true
    end
    
    it 'is false if date is after contest closes' do
      expect(ContestRules.contest_open?(@after)).to eql false
    end
  end

  describe '#voting_open?' do 

    before :all do 
      @after = ContestRules::JUDGING_CLOSES + 1.days
    end

    it 'is false before contest opens' do 
      expect(ContestRules.voting_open?(@before)).to eql false
    end

    it 'is true if date is on contest opens date' do 
      expect(ContestRules.voting_open?(ContestRules::CONTEST_OPENS)).to eql true
    end

    it 'is true if date is during the contest' do
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