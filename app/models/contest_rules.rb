class ContestRules
    CONTEST_OPENS  = DateTime.new(2014, 4, 14)
    CONTEST_CLOSES = DateTime.new(2014, 5, 15, 4)

    JUDGING_OPENS  = DateTime.new(2014, 5, 15)
    JUDGING_CLOSES = DateTime.new(2014, 5, 22, 23, 59)

    VOTING_CLOSES  = JUDGING_CLOSES

    VOTES_PER_DAY_PER_IP   = 3
    ENTRIES_PER_CONTESTANT = 5

    JUDGING_SHORTLIST_MAX_PER_CATEGORY = 2

    # prize keys
    REQUIRED_PRIZES = [
        :grand_prize,
        :made_in_canada,
        :flora_1st,
        :flora_2nd,
        :flora_3rd,
        :fauna_1st,
        :fauna_2nd,
        :fauna_3rd,
        :landscapes_1st,
        :landscapes_2nd,
        :landscapes_3rd
    ]

    OPTIONAL_PRIZES = [
        :highest_bid,
        :peoples_choice,
        :honourable_mention
    ]

    # TODO: prize model
    PRIZE_DESCRIPTIONS = {
        grand_prize: "Grand",
        made_in_canada: "Made in Canada",
        peoples_choice: "People's Choice",
        highest_bid: "Highest Bid",
        flora_1st:"Flora, 1st Place",
        flora_2nd:"Flora, 2nd Place",
        flora_3rd:"Flora, 3rd Place",
        fauna_1st:"Fauna, 1st Place",
        fauna_2nd:"Fauna, 2nd Place",
        fauna_3rd:"Fauna, 3rd Place",
        landscapes_1st:"Landscapes, 1st Place",
        landscapes_2nd:"Landscapes, 2nd Place",
        landscapes_3rd:"Landscapes, 3rd Place"
    }

    def self.contest_open?(today = nil)
        today ||= DateTime.now
        CONTEST_OPENS <= today && today <= CONTEST_CLOSES
        # debug
        true
    end

    def self.voting_open?(today = nil)
        today ||= DateTime.now
        CONTEST_OPENS <= today && today <= VOTING_CLOSES
    end

    # method to add :winner => :prize to each photo in a photo_score array (sorted desc by score)
    def self.apply_winners photo_scores
        prizes = {
            "Canada"     => [:made_in_canada],
            "Flora"      => [:flora_1st, :flora_2nd, :flora_3rd],
            "Fauna"      => [:fauna_1st, :fauna_2nd, :fauna_3rd],
            "Landscapes" => [:landscapes_1st, :landscapes_2nd, :landscapes_3rd]
        }
        
        photo_scores.each_with_index do |photo_score, index|
            photo_score[:winner] = :grand_prize and next if index.zero?

            if prizes[photo_score[:category]].any?
                photo_score[:winner] = prizes[photo_score[:category]].shift
            end
        end

        photo_scores
    end

    def self.prizes
        REQUIRED_PRIZES + OPTIONAL_PRIZES
    end
end