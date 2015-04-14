class AdminPanel
  attr_accessor :flagged_comments, :admin, :photos, :judges

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
end