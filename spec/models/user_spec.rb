require 'spec_helper'

describe User do 
  before :each do 
    @user = User.new :id            => 'valid@email.com',
                     :first_name    => 'Jenny',
                     :last_name     => 'Smith',
                     :phone         => '8675309',
                     :password_hash => User::Password.create('secret'),
                     :password_salt => BCrypt::Engine.generate_salt
  end

  context "validations" do 
    it "must have an email address (id)" do 
      @user.unset :id
      expect { @user.save! }.to raise_error Mongoid::Errors::Validations
    end

    it "must have unique email address" do
      # dups/clones do not inherit id in mongoid
      other = @user.dup
      other.email = @user.email
      other.save

      expect { @user.save! }.to raise_error Mongoid::Errors::Validations
    end 

    xit "must have email in format (\w\.?)+@(\w.?)\.\w{2,4}" do
      @user.id = 'bademail.com'
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
      expect{ @user }.to_not raise_error
      @user.unset :phone
      expect{ @user }.to_not raise_error
    end

    xit "must have confirmed password"
  end

  describe '#email' do 
    it "accesses id via email" do 
      expect(@user.email).to eql 'valid@email.com'
    end
  end

  describe '#encrypt_password' do 
    xit 'it encrypts the password'
  end
end