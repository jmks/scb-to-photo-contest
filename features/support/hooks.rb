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
  @registered = registered_user
end

Before '@registered_and_signed_in' do 
  @registered = registered_user

  log_in_as @registered

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

Before "@admin" do 
  @admin = FactoryGirl.create :admin
  log_in_as @admin
end

Before '@photos' do 
  @photos = FactoryGirl.create_list :photo, 5
end

Before '@photo_upload' do 
  FakeWeb.register_uri(:post, 'https://s3.amazonaws.com/scbto-photos-originals',
      :status => [303, 'See Other'],
      :location => "http://example.com/upload_complete")
end

def registered_user
  user = FactoryGirl.build(:contestant)
  user[:password] = "password123"
  user.save!

  user
end

def log_in_as user
  visit new_contestant_session_path
  fill_in 'contestant[email]',    with: user.email
  fill_in 'contestant[password]', with: user.password

  click_button 'Sign in'
end