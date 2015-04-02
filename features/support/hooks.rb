# purge database before every scenario
Before do |scenario|
  Mongoid.purge!

  ContestRules.redefine_const("CONTEST_OPENS", 1.day.ago)
  ContestRules.redefine_const("CONTEST_CLOSES", 1.day.from_now)
  ContestRules.redefine_const("JUDGING_OPENS", 1.day.from_now)
  ContestRules.redefine_const("JUDGING_CLOSES", 2.day.from_now)
  ContestRules.redefine_const("VOTING_CLOSES", 2.days.from_now)
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

    # go back home to start
    visit root_path
end

Before '@photo_details' do 
    @photo = FactoryGirl.create(:photo, owner: @registered)
end

Before '@photo_uploaded' do
    @photo = FactoryGirl.create(:photo, owner: @registered)

    @photo.original_url = "http://notrealurl.butnotablank.string"
    @photo.save
    # @photo should be :uploaded
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

Before '@photo_upload' do 
    FakeWeb.register_uri(:post, 'https://s3.amazonaws.com/scbto-photos-originals',
        :status => [303, 'See Other'],
        :location => "http://example.com/upload_complete")
end