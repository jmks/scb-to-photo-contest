# purge database before every scenario
Before do |scenario|
  Mongoid.purge!

  # some black magic to get the current "state" of the contest
  # to be open
  ContestRules::CONTEST_OPENS  = 1.day.ago
  ContestRules::CONTEST_CLOSES = ContestRules::JUDGING_OPENS = 1.day.from_now
  ContestRules::JUDGING_CLOSES = ContestRules::VOTING_CLOSES = 2.days.from_now
end

Before '@registered' do 
  @registered = FactoryGirl.build(:contestant)
  @registered[:password] = "password123"
  @registered.save!
end

Before '@registered_and_signed_in' do 
    @registered = FactoryGirl.build(:contestant)
    @registered[:password] = "password123"
    @registered.save!

    # signin user
    visit new_contestant_session_path
    fill_in 'contestant[email]',    with: @registered.email
    fill_in 'contestant[password]', with: @registered.password

    click_button 'Sign in'

    @current_contestant = Contestant.where(email: @registered.email).first

    # go back home to start
    visit root_path
end

Before '@photo_details' do 
    @photo = FactoryGirl.create(:photo, owner: @current_contestant)
end

Before '@unregistered' do 
  @unregistered = FactoryGirl.build(:contestant)
  @unregistered[:password] = "password123"
end

Before '@photo' do
  @photo = FactoryGirl.create(:photo)
end

Before '@photos' do 
  @photos = FactoryGirl.create_list :photo, 5
end