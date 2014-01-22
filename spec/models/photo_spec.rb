require 'spec_helper'

describe Photo do 
  before :each do
    @contestant = Contestant.create :id         => 'valid@email.com',
                                    :first_name => 'Jenny',
                                    :last_name  => 'Smith'

    @photo = Photo.new :title    => 'A Walk in the Park',
                       :category => 'landscapes',
                       :owner    => @contestant
  end

  context "fail validations" do 
    it 'must have a title' do
      @photo.unset :title
      expect { @photo.save! }.to raise_error Mongoid::Errors::Validations
    end

    it 'must be in a category' do 
      @photo.unset :category
      expect { @photo.save! }.to raise_error Mongoid::Errors::Validations
    end

    it 'can not set votes' do 
      @photo.votes = 1_000_000
      expect { @photo.save! }.to raise_error Mongoid::Errors::Validations
    end

    it 'can not set likes' do 
      @photo.likes = 1_000_000
      expect { @photo.save! }.to raise_error Mongoid::Errors::Validations
    end

    it 'can not set favourites' do 
      @photo.favourites = 1_000_000
      expect { @photo.save! }.to raise_error Mongoid::Errors::Validations
    end

    it 'must be owned by a contestant' do 
      @photo.unset :owner
      expect { @photo.save! }.to raise_error Mongoid::Errors::Validations
    end
  end

  context "pass validations" do
    xit 'has optional description' do 
      @photo.description = "So a clown walks into a bar..."
      expect(@photo.save!).to_not raise_error
    end

    it 'creates a photo' do 
      expect(Photo.new).to be_an_instance_of Photo
    end

    xit 'creates a valid photo' do 
      expect { @photo.save! }.to_not raise_error
    end
  end

  context 'ownership' do 
    it 'has one owner' do 
      expect(@photo.owner).to be_an_instance_of Contestant
    end

    it 'has correct owner' do 
      expect(@photo.owner).to be @contestant
    end

    it 'is owned by the contestant' do 
      expect(@photo.owner.entries).to include @photo
    end
  end

  context '#comments' do 
    xit "creates comments" do 
      @photo.save
      expect(@photo.comments.create name: "Quagmire", text: "Giggity!").to be_an_instance_of Comment
    end

    xit "has many comments" do 
      @photo.save
      @photo.comments.create name: "Quagmire", text: "Gigigity, gigitity!"
      @photo.comments.create name: "Pea tear griffin", text: "Do you know the word?"
      expect(@photo.comments.length).to be 2
    end
  end

  context 'tags' do

  end

  context 'photo path' do 

  end

  context "voting" do 
    it "has 0 votes by default" do 
      expect(@photo.votes).to eql 0
    end

    it "has 0 likes by default" do 
      expect(@photo.likes).to eql 0
    end

    it "has 0 favourites by default" do 
      expect(@photo.favourites).to eql 0
    end

    xit "is favourited by many contestants"
  end

  context "indexes" do
    xit "tags"
    xit "category"
    xit "created_at"
  end
end