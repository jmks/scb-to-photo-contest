class ContestRules
    CONTEST_OPENS  = DateTime.new(2014, 4, 14)
    CONTEST_CLOSES = DateTime.new(2014, 5, 15, 4)

    JUDGING_OPENS  = DateTime.new(2014, 5, 15)
    JUDGING_CLOSES = DateTime.new(2014, 5, 22, 23, 59)

    VOTING_CLOSES  = JUDGING_CLOSES

    VOTES_PER_DAY_PER_IP   = 3
    ENTRIES_PER_CONTESTANT = 5

    def self.contest_open?(today = nil)
        today ||= DateTime.now
        CONTEST_OPENS <= today && today <= CONTEST_CLOSES
    end

    def self.voting_open?(today = nil)
        today ||= DateTime.now
        CONTEST_OPENS <= today && today <= VOTING_CLOSES
    end
end