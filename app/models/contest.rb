class Contest
  attr_accessor :open_date, :close_date, :entries_per_contestant
  attr_accessor :configuration_variables

  # Judgeable?
  attr_accessor :judging_open, :judging_close, :shortlist_size_per_category

  # Voteable?
  attr_accessor :voting_close, :votes_per_day_per_ip

  # state_machine based contest state

  state_machine :state, initial: :configuration do 

    # Events

    # metadata setup
    event :finalize_configuration do 
      # check contest open_date
      transition :configuration => :closed
    end

    # contest opened on opening date
    event :open_contest do
      transition :closed => :open
    end

    # contest closed on closing date, move to prize assigment
    event :close_contest do
      transition all => :closed
    end

    event :assign_prizes do 
      transition all => :prize_assignment
    end

    # prize assignment strategy can alter this?
    # eg prize_assignment => judging_shortlist_assignment => judging_numerical_assignment =>
    #    admin_required_assigment => admin_optional_assigment => finalize_contest

    # finalized contest is completed
    event :finalize_contest do 
      transition all => :complete
    end

    # Transitions

    before_transition :configuration => any, :do => :contest_configured?
  end

  def initialize properties={}

    # TODO: will X-able be able to add more properties when mixed in?
    @configuration_variables = [:open_date, :close_date, :entries_per_contestant]

    super() # alternatively, initialize_state_machines
  end

  def configured?
    variables_set  = configuration_variables.map { |v| "@#{v}"}.all? {|v| instance_variable_get(v) }
    sensical_dates = open_date < close_date if variables_set

    [variables_set, sensical_dates].all?
  end

  private 

  def contest_configured?
    throw :halt unless configured?
  end
end