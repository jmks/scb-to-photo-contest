require 'spec_helper'

describe 'Winner' do 

  before :all do 
    @prizes = ContestRules::REQUIRED_PRIZES
  end

  def fully_assign_prizes
    create_winners @prizes
  end

  def partially_assign_prizes
    some_prizes = @prizes.sample(@prizes.length - 1).uniq
    create_winners some_prizes
  end

  def create_winners prizes
    prizes.each do |prize|
      create :winner, prize: prize
    end
  end

  describe 'self.assignments_remaining?' do 
    it 'returns true for empty prize assignments' do 
      expect(Winner.assignments_remaining?).to eql true
    end

    it 'returns true if required prizes need to be assigned' do 
      partially_assign_prizes

      expect(Winner.assignments_remaining?).to eql true
    end

    it 'returns false if all required prizes have been assigned' do 
      fully_assign_prizes

      expect(Winner.assignments_remaining?).to eql false
    end
  end

  describe 'self.assignments_remaining' do 
    it 'return an empty list when all prizes have been assigned' do 
      fully_assign_prizes

      expect(Winner.assignments_remaining).to match_array []
    end

    it 'returns prizes not yet assigned' do 
      assigned_prizes = partially_assign_prizes

      expect(Winner.assignments_remaining).to eql (@prizes - assigned_prizes)
    end
  end

  describe 'self.assignments_complete?' do 
    it 'returns true when all prizes are assigned' do 
      fully_assign_prizes

      expect(Winner.assignments_complete?).to eql true
    end

    it 'returns false when some or no prizes assigned' do 
      partially_assign_prizes

      expect(Winner.assignments_complete?).to eql false
    end
  end

  describe 'self.winners_by_award' do 
    it 'returns an empty hash with no prizes assigned' do 
      expect(Winner.winners_by_award).to eql Hash.new
    end

    it 'returns a hash award => winner' do 
      expected = {}
      @prizes.each do |prize|
        winner = create :winner, prize: prize
        expected[prize] = winner.photo
      end

      expect(Winner.winners_by_award).to eql expected
    end
  end

  describe 'prize validation' do 
    context 'validates' do 
      it 'an unassigned, known prize' do 
        winner = build :winner, prize: @prizes.first

        expect(winner).to be_valid
      end
    end

    context 'does not validate' do 
      it 'unknown prizes' do 
        strange_winner = build :winner, prize: 'Super karate monkey deathcar'

        expect(strange_winner).to_not be_valid
        expect(strange_winner.errors[:prize].first).to include 'not found'
      end

      it 'assigned prizes' do 
        winner         = create :winner
        another_winner = build :winner, prize: winner.prize

        expect(another_winner).to_not be_valid
        expect(another_winner.errors[:prize].first).to include 'already assigned'
      end
    end
  end
end