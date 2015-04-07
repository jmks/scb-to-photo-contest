require 'spec_helper'

describe Contestant do 

  before :each do 
    @contestant = build(:contestant)
    @photo = build(:photo)
  end

  context "when validating" do 
    it "must have an email address" do 
      @contestant.unset :email

      expect(@contestant).to_not be_valid
      expect(@contestant).to have_error :email
      expect(@contestant).to have_error_message_for(:email, "blank")
    end

    it "must have unique email address" do
      @contestant.save
      # same fields but new _id generated
      another = @contestant.dup
      
      expect(another).to_not be_valid
      expect(another).to have_error :email
      expect(another).to have_error_message_for(:email, "already taken")
    end

    context "email address format" do 
      it "should be invalid for malformed email addresses" do 
        bad_emails = %w{bademail.com chunkeymonkey@gmail @tenderlove.io eg@.com}
      
        bad_emails.each do |email|
          @contestant.email = email

          expect(@contestant).to_not be_valid
        expect(@contestant).to have_error :email
        expect(@contestant).to have_error_message_for(:email, "valid")
        end
      end

      it "should be valid for common email address formats" do 
        good_emails = %w{jason@exapmle.com j.m.k.s@j.km.s.ca}

        good_emails.each do |email|
          @contestant.email = email

          expect(@contestant).to be_valid
        end
      end
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
    it 'is true if phone number is given' do 
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
end