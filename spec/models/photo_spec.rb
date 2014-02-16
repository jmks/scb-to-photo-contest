require 'spec_helper'

describe Photo do 
  before :each do
    @contestant = Contestant.create :email      => 'valid@email.com',
                                    :password   => 'supersecret',
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

    it 'must be owned by a contestant' do 
      @photo.save
      @photo.unset :owner
      expect { @photo.save! }.to raise_error Mongoid::Errors::Validations
    end
  end

  context "pass validations" do
    it 'has optional description' do 
      expect { @photo.save! }.to_not raise_error
      @photo.description = "So a clown walks into a bar..."
      expect { @photo.save! }.to_not raise_error
    end

    it 'creates a photo' do 
      expect(Photo.new).to be_an_instance_of Photo
    end

    it 'creates a valid photo' do 
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
    it "creates comments" do 
      @photo.save
      expect(@photo.comments.create name: "Quagmire", text: "Giggity!").to be_an_instance_of Comment
    end

    it "has many comments" do 
      @photo.save
      @photo.comments.create name: "Quagmire", text: "Giggity, giggity!"
      @photo.comments.create name: "Pea tear griffin", text: "Do you know the word?"
      expect(@photo.comments.length).to be 2
    end
  end

  context 'tags' do
    describe '#tagged?' do 
      it 'is false for tags not present' do
        expect(@photo.tagged? "pretty").to eql false
      end

      it 'is true for present tags' do
        @photo.push tags: 'silly'
        expect(@photo.tagged?('silly')).to eql true
      end
    end

    describe '#add_tag' do 
      it 'adds a tag' do 
        @photo.add_tag "super-duper"
        expect(@photo.tags).to include("super-duper")
      end

      it 'adds many tags' do 
        expect {
          @photo.add_tag "stupendous"
          @photo.add_tag "snowy"
        }.to change { @photo.tags.length }.from(0).to(2)
      end
    end
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

    it "is favourited by many contestants" do 
      another = @contestant.dup
      @contestant.favourite_photo @photo
      another.update_attributes(email: 'spengler@ghostbusters.com', password: 'egon')
      another.save
      another.favourite_photo @photo

      expect(@photo.favourites).to eql 2
    end
  end

  context "index on" do
    # Collection.where(criteria).explain[:cursor].starts_with? 'BtreeCursor'

    before :all do 
      @indexes = Photo.collection.indexes
    end

    xit "tags asc" do 
      expect(@indexes[tags: 1]).to be_true
    end

    xit "category asc" do 
      expect(@indexes[category: 1]).to be_true
    end

    xit "created_at desc" do 
      expect(@indexes[created_at: -1]).to be_true
    end
  end
end