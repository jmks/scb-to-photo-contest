class ContestRules
  CONTEST_OPENS  = DateTime.new(2014, 4, 14)
  CONTEST_CLOSES = DateTime.new(2014, 5, 15, 4)

  JUDGING_OPENS  = DateTime.new(2014, 5, 15)
  JUDGING_CLOSES = DateTime.new(2014, 5, 22, 23, 59)

  VOTING_CLOSES  = JUDGING_CLOSES

  VOTES_PER_DAY_PER_IP   = 3
  ENTRIES_PER_CONTESTANT = 5

  JUDGING_SHORTLIST_MAX_PER_CATEGORY = 2

  def self.contest_open?(today = nil)
    today ||= DateTime.now
    CONTEST_OPENS <= today && today <= CONTEST_CLOSES
  end

  def self.voting_open?(today = nil)
    today ||= DateTime.now
    CONTEST_OPENS <= today && today <= VOTING_CLOSES
  end

  # state_machine based contest state

  state_machine :state, initial: :configuration do 

    # metadata setup
    event :finalize_configuration do 
      transition :configuration => :closed
    end

    # contest opened on opening date
    event :open_contest do
      transition :closed => :open
    end

    # contest closed on closing date, move to prize assigment
    event :close_contest do
      transition all => :prize_assignment
    end

    # prize assignment strategy can alter this?

    # finalize contest is completed
    event :finalize_contest do 
      transition all => :complete
    end
  end
end