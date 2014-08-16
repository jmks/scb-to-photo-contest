class Contest
  attr_accessor :open_date, :close_date, :entries_per_contestant
  attr_accessor :configuration_variables

  # Judgeable?
  attr_accessor :judging_open, :judging_close, :shortlist_size_per_category

  # Voteable
  attr_accessor :voting_close, :votes_per_day_per_ip

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

  def initialize properties={}

    # TODO: will X-able be able to add more properties when mixed in?
    @configuration_variables = [:open_date, :close_date, :entries_per_contestant]

    super()
  end

  def configured?
    configuration_variables.map { |v| "@#{v}"}.all? {|v| instance_variable_get(v) }
  end

  private

  def add_configuration_variables config_variables
    config_variables += config_variables
  end
end