require 'spec_helper'

describe Vote do 

  before :each do 
    # random ip doesn't have to be assignable
    @vote = Vote.new id: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)]
    @max_votes = ContestRules::VOTES_PER_DAY_PER_IP
  end

  describe '#vote?' do 
    it 'new ips can vote' do 
      expect(Vote.new).to be_vote
    end

    it 'is false when maximum votes reached' do 
      @max_votes.times { @vote.vote }
      expect(@vote).to_not be_vote
    end

    it 'multiple different ips can vote' do 
      5.times { expect(Vote.new).to be_vote }
    end
  end

  describe '#vote' do 
    context 'voting multiple times in one day' do 

      it 'valid voting increases votes_today by 1' do 
        expect {
          @vote.vote
        }.to change { @vote.votes_today }.by 1
      end

      it 'can vote multiple times' do 
        valid_vote_amount = @max_votes > 1 ? @max_votes - 1 : 1
        expect { 
          valid_vote_amount.times { @vote.vote }
        }.to change { @vote.votes_today }.by valid_vote_amount 
      end

      it 'fails after maximum voting reached' do 
        @max_votes.times { @vote.vote }

        expect(@vote.vote).to eql false
      end
    end

    context 'voting on subsequent days' do

      it 'resets votes_today' do 
        @vote.vote
        @vote.save!

        # implementation dependant
        expect(Date).to receive(:today).and_return { 1.day.from_now }

        expect {
          @vote.vote
          }.to change { @vote.votes_today }.by(0)
      end

      it 'increases votes by votes_today' do
        @max_votes.times { @vote.vote }

        # implementation dependant
        expect(Date).to receive(:today).and_return { 1.day.from_now }

        expect {
          @vote.vote
        }.to change { @vote.votes }.from(0).to(5)
      end
    end
  end

  describe '#votes_remaining' do 
    it 'new voters have full vote allotment' do 
      expect(@vote.votes_remaining).to eql @max_votes
    end

    it 'voting decreases votes_remaining' do 
      expect {
        @vote.vote
      }.to change { @vote.votes_remaining }.from(@max_votes).to(@max_votes - 1)
    end

    it 'voting your full allotment leaves you with 0 votes remaining' do 
      expect {
        (@max_votes).times { @vote.vote }
      }.to change { @vote.votes_remaining }.from(@max_votes).to(0)
    end
  end

  describe 'self.votes_remaining' do 
    it 'behaves like votes_remaining' do 
      expect(Vote.votes_remaining(@vote.ip)).to eql @max_votes

      expect {
        @vote.vote
        @vote.save
      }.to change { Vote.votes_remaining(@vote.ip) }.by -1
      
      (@max_votes - 1).times { @vote.vote }

      expect(Vote.votes_remaining(@vote.ip)).to eql 0
    end
  end

  describe '#total_votes' do 
    it 'starts at 0' do 
      expect(@vote.total_votes).to be_zero
    end

    it 'increases with votes' do 
      expect {
        @max_votes.times { @vote.vote }
      }.to change { @vote.total_votes }.by @max_votes
    end

    it 'sums votes and votes_today' do 
      3.times { @vote.vote }

      # implementation dependant
      expect(Date).to receive(:today).exactly(3).times.and_return { 1.days.from_now }

      3.times { @vote.vote }

      expect(@vote.total_votes).to eql 6
    end
  end
end