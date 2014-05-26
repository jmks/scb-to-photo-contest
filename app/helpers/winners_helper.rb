module WinnersHelper
  def winner_select_choices
    Winner.assignments_remaining.map { |prize| [pp_prize(prize), prize] }
  end
end