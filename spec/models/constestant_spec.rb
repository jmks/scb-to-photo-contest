require 'spec_helper'

describe Contestant do 

  before :each do 
    @contestant = Contestant.new
  end

  describe '#admin?' do 
    it 'is not an admin' do 
      expect(@contestant).to_not be_admin
    end
  end
end