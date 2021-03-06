class Vote
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :_id,         as: :ip
  field :date,        type: Date,    default: Date.today
  field :votes,       type: Integer, default: 0
  field :votes_today, type: Integer, default: 0

  def vote?(today=Date.today)
    # update votes_today
    if date != today
      inc votes: votes_today
      set votes_today: 0
      set date: today
    end

    votes_today < ContestRules::VOTES_PER_DAY_PER_IP
  end

  def vote(today=Date.today)
    if vote?(today)
      inc votes_today: 1
      true
    else
      false
    end
  end

  def votes_remaining
    vote? ? ContestRules::VOTES_PER_DAY_PER_IP - votes_today : 0
  end

  def total_votes
    votes_today + votes
  end

  def self.votes_remaining ip
    begin
      Vote.find(ip).votes_remaining
    rescue
      ContestRules::VOTES_PER_DAY_PER_IP
    end
  end
end