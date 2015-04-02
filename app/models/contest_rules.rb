module ContestRules
  CONTEST_OPENS  = DateTime.new(2014, 4, 14)
  CONTEST_CLOSES = DateTime.new(2014, 5, 15, 4)

  JUDGING_OPENS  = DateTime.new(2014, 5, 15)
  JUDGING_CLOSES = DateTime.new(2014, 5, 22, 23, 59)

  VOTING_CLOSES  = JUDGING_CLOSES

  VOTES_PER_DAY_PER_IP   = 3
  ENTRIES_PER_CONTESTANT = 5

  JUDGING_SHORTLIST_MAX_PER_CATEGORY = 2

  def self.contest_open?(today = DateTime.now)
    today ||= DateTime.now
    today.between?(CONTEST_OPENS, CONTEST_CLOSES)
  end

  def self.voting_open?(today = DateTime.now)
    today.between?(CONTEST_OPENS, VOTING_CLOSES)
  end

  # quietly redefine constant values
  # should only be used for testing
  def self.redefine_const(const, value)
    send(:remove_const, const) if const_defined?(const)
    const_set(const, value)
  end
end