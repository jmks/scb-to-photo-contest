class AdminPanel
  attr_accessor :admin, :new_contest, :current_contest
  attr_accessor :flagged_comments, :photos, :judges, :contests

  def initialize &block
    yield self if block_given?
  end

  def judges_completed_scoring
    Judge.completed_scoring
  end

  def notify_winners?
    return false if Winner.all_notified?

    Winner.assignments_complete?
  end

  def current_contest?
    current_contest.present?
  end
end
