# purge database before every scenario
Before do |scenario|
  Mongoid.purge!
end

Before '@registered' do 
  @registered = FactoryGirl.build(:contestant)
  @registered[:password] = "password123"
  @registered.save!
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