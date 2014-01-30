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

    it "has optional phone number" do
      expect { @user }.to_not raise_error
      @user.unset :phone
      expect { @user }.to_not raise_error
    end

    xit "must have password_hash"
    xit "must have password_salt"
  end

  describe '#encrypt_password' do 
    xit 'it encrypts the password'
  end
end