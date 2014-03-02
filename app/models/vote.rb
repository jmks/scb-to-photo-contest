class Vote
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :_id,         as: :ip
  field :date,        type: Date,    default: Date.today
  field :votes,       type: Integer, default: 0
  field :votes_today, type: Integer, default: 0

  index({ ip: 1 }, { unique: true })

  def vote?
    if date == Date.today 
      votes_today < ContestRules::VOTES_PER_DAY_PER_IP
    else
      true
    end
  end

  def vote
    if vote?
      if date != Date.today
        date = Date.today
        inc votes: votes_today
      end
      
      inc votes_today: 1
      true
    else
      false
    end
  end
end