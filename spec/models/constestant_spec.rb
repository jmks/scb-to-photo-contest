require 'spec_helper'

describe Contestant do 

  before :each do 
    @contestant = build(:contestant)
    @photo = build(:photo)
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
        expect(@contestant).to be_valid
        expect(build(:contestant, phone: "1-(555)-867-5309ext.123")).to be_valid
        expect(build(:contestant, phone: "555.867.5309")).to be_valid
      end
    end

  end

  context 'voting' do 
    describe '#vote_for' do 
      it 'votes for a photo' do 
        @contestant.vote_for @photo
        expect(@contestant.voted_photo_ids).to include(@photo.id)
      end

      it 'does not double vote for same photo' do 
        3.times { @contestant.vote_for @photo }
        expect(@contestant.voted_photo_ids.reject { |id| id != @photo.id }.length).to eql 1
      end

      it 'votes for many photos' do
        another = build(:photo)

        @contestant.vote_for @photo
        @contestant.vote_for another 

        expect(@contestant.voted_photo_ids.length).to eql 2
      end
    end
  end

  context 'index' do 
    xit 'on email'
  end
end