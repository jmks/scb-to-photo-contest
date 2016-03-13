# purge database before every scenario
Before do |scenario|
  Mongoid.purge!

  ContestRules.redefine_const("CONTEST_OPENS", 1.day.ago)
  ContestRules.redefine_const("CONTEST_CLOSES", 1.day.from_now)
  ContestRules.redefine_const("JUDGING_OPENS", 1.day.from_now)
  ContestRules.redefine_const("JUDGING_CLOSES", 2.day.from_now)
  ContestRules.redefine_const("VOTING_CLOSES", 2.days.from_now)
end

Before "@photo_upload" do
  FakeWeb.register_uri(:post, "https://s3.amazonaws.com/scbto-photos-originals",
      :status => [303, "See Other"],
      :location => "http://example.com/upload_complete")
end

def registered_contestant
  FactoryGirl.build(:contestant).tap do |c|
    c[:password] = "password123"
    c.save!
  end
end

def log_in_as user
  visit new_contestant_session_path
  fill_in "contestant[email]",    with: user.email
  fill_in "contestant[password]", with: user.password

  click_button "Sign in"
end
