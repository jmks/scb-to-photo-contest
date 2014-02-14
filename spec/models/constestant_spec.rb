require 'spec_helper'

describe Contestant do 

  before :each do 
    @contestant = Contestant.new :email      => 'valid@email.com',
                                 :password   => 'supersecret',
                                 :first_name => 'Jenny',
                                 :last_name  => 'Smith',
                                 :phone      => '8675309'
    @photo = Photo.new :title    => 'Walk in the park',
                       :category => 'landscapes',
                       :owner    => @contestant
  end

  context "validations" do 
    it "must have an email address" do 
      @contestant.unset :email
      expect { @contestant.save! }.to raise_error Mongoid::Errors::Validations
    end

    it "must have unique email address" do
      @contestant.save
      # same fields but new _id generated
      another = @contestant.dup
      expect { another.save! }.to raise_error Mongoid::Errors::Validations
    end 

    it "must have email in format (\w\.?)+@(\w.?)\.\w{2,4}" do
      @contestant.email = 'bademail.com'
      expect(@contestant).to be_invalid
      @contestant.email = 'chunkeymonkey@gmail'
      expect(@contestant).to be_invalid
    end

    it "must have first name" do 
      @contestant.unset :first_name
      expect {@contestant.save! }.to raise_error Mongoid::Errors::Validations
    end

    it "must have last name" do 
      @contestant.unset :last_name
      expect {@contestant.save! }.to raise_error Mongoid::Errors::Validations
    end

    it 'has phone number in format ddd-ddd-dddd[xd+]?' do 
      @contestant.phone = '234-567-91011'
      expect(@contestant).to_not be_valid
    end
  end

  describe '#phone?' do 
    it 'is true if data is given' do 
      expect(@contestant).to be_phone
    end

    it 'is false for nil or empty' do 
      @contestant.phone = ''
      expect(@contestant).to_not be_phone

      @contestant.unset :phone
      expect(@contestant).to_not be_phone
    end
  end

  context 'before_validation' do 
    
    describe '#normalize_phone' do 
      it 'reformats phone numbers to \d{3}-\d{3}-\d{4}(?:x\d+)?' do 
        @contestant.phone = "1-(555)-867-5309ext.123"
        expect(@contestant).to be_valid
        @contestant.phone = "555.867.5309"
        expect(@contestant).to be_valid
      end
    end

  end

  describe '#is_favourite?' do 
    it 'is false if contestant has no favourites' do 
      expect(@contestant.is_favourite?(@photo)).to eql false
    end

    it 'is true if favourited by contestant' do 
      @contestant.favourite_photo(@photo)
      expect(@contestant.is_favourite?(@photo)).to eql true
    end
  end

  describe '#defavourite_photo' do

    context 'when contestant has no favourites' do 
      it "does not change contestant's favourites" do 
        expect { 
          @contestant.defavourite_photo @photo
        }.to_not change { @contestant.favourite_photo_ids.length }.from(0).to(0)
      end

      it "does not change photos's favourites" do 
        expect {
          @contestant.defavourite_photo @photo
        }.to_not change { @photo.favourites }.from(0).to(0)
      end
    end

    context 'when contestant does favourites photo' do 
      it "removes the photo from contestant's favourites" do 
        @contestant.favourite_photo @photo
        expect { 
          @contestant.defavourite_photo @photo
        }.to change { @contestant.favourite_photo_ids.length }.from(1).to(0)
      end
      
      it "decreases photo's favourites count by 1" do 
        @contestant.favourite_photo @photo
        expect { 
          @contestant.defavourite_photo @photo
        }.to change { @photo.favourites }.from(1).to(0)
      end
    end

  end

  describe '#favourite_photo' do 
    before :each do 
      @contestant.save
      @photo.save
    end

    it 'adds a photo to favourites by id' do
      expect {
        @contestant.favourite_photo(@photo)
      }.to change { @contestant.favourite_photo_ids.length }.by(1)
    end

    it 'add the photo to favourites' do 
      @contestant.favourite_photo @photo
      expect(@contestant.favourite_photo_ids).to include(@photo.id)
    end

  end

  context 'index' do 
    xit 'on email'
  end
end