require 'spec_helper'

describe Admin do 

  before :each do 
    @admin = Admin.new
  end

  describe '#admin?' do 
    it 'is an admin' do 
      expect(@admin).to be_admin
    end
  end
end