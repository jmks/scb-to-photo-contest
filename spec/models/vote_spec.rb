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
  end

  describe '#vote' do 
    context 'voting multiple times in one day' do 

      it 'valid voting increases votes_today by 1' do 
        expect {
          @vote.vote
        }.to change { @vote.votes_today }.by 1
      end

      it 'can vote multiple times' do 
        valid_vote_amout = @max_votes > 1 ? @max_votes - 1 : 1
        expect { 
          valid_vote_amout.times { @vote.vote }
        }.to change { @vote.votes_today }.by valid_vote_amout 
      end
    end

    context 'voting on subsequent days' do

      it 'resets votes_today' do 
        @vote.vote
        @vote.save!
        # implementation dependant
        expect(Date).to receive(:today).twice.and_return { 1.day.from_now }

        expect {
          @vote.vote
          }.to change { @vote.votes_today }.by(0)
      end

      it 'increases votes by votes_today' do
        @max_votes.times { @vote.vote }
        expect(Date).to receive(:today).twice.and_return { 1.day.from_now }

        expect {
          @vote.vote
        }.to change { @vote.votes }.from(0).to(5)
      end
    end
  end
end