class ContestRules
    CONTEST_OPENS  = DateTime.new(2014, 4, 14)
    CONTEST_CLOSES = DateTime.new(2014, 5, 14, 23, 59)

    JUDGING_OPENS  = DateTime.new(2014, 5, 15)
    JUDGING_CLOSES = DateTime.new(2014, 4, 22)

    VOTES_PER_DAY_PER_IP = 3
    ENTRIES_PER_CONTESTANT = 5

    def self.contest_open?(today = nil)
        today ||= DateTime.now
        CONTEST_OPENS <= today && today <= CONTEST_CLOSES
    end
end