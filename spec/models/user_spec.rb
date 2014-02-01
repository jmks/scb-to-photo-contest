require 'spec_helper'

describe User do 
  before :each do 
    @user = User.new :email         => 'valid@email.com',
                     :first_name    => 'Jenny',
                     :last_name     => 'Smith',
                     :phone         => '8675309',
                     :password_hash => User::Password.create('secret'),
                     :password_salt => BCrypt::Engine.generate_salt
  end

  context "validations" do 
    it "must have an email address" do 
      @user.unset :email
      expect { @user.save! }.to raise_error Mongoid::Errors::Validations
    end

    it "must have unique email address" do
      @user.save
      # same fields but new _id generated
      another = @user.dup
      expect { another.save! }.to raise_error Mongoid::Errors::Validations
    end 

    it "must have email in format (\w\.?)+@(\w.?)\.\w{2,4}" do
      @user.email = 'bademail.com'
      expect(@user).to be_invalid
      @user.email = 'chunkeymonkey@gmail'
      expect(@user).to be_invalid
    end

    it "must have first name" do 
      @user.unset :first_name
      expect {@user.save! }.to raise_error Mongoid::Errors::Validations
    end

    it "must have last name" do 
      @user.unset :last_name
      expect {@user.save! }.to raise_error Mongoid::Errors::Validations
    end

    it 'has phone number in format ddd-ddd-dddd[xd+]?' do 
      @user.phone = '234-567-91011'
      expect(@user).to_not be_valid
    end
  end

  describe '#has_phone?' do 
    it 'is true if data is given' do 
      expect(@user).to be_has_phone
    end

    it 'is false for nil or empty' do 
      @user.phone = ''
      expect(@user).to_not be_has_phone

      @user.unset :phone
      expect(@user).to_not be_has_phone
    end
  end

  context 'before_validation' do 
    describe '#normalize_phone' do 
      it 'reformats phone numbers to \d{3}-\d{3}-\d{4}(?:x\d+)?' do 
        @user.phone = "1-(555)-867-5309ext.123"
        expect(@user).to be_valid
        @user.phone = "555.867.5309"
        expect(@user).to be_valid
      end
    end
  end

  describe '#encrypt_password' do 
    xit 'it encrypts the password'
  end

  describe 'entering a photo' do 
    xit 'must have a valid phone number'
  end
end