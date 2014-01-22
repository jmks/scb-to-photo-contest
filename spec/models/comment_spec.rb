require 'spec_helper'

describe Comment do 
  before :each do 
    @photo = Photo.create :title    => 'Walk in the park',
                          :category => 'landscapes'
  end

  context "fail validations" do
    it "must have a name" do
      expect(Comment.new(:text => "Awesome!")).to_not be_valid
    end

    it "must have text" do
      expect(Comment.new(:name => "Jimbob")).to_not be_valid
    end

    it "must belong to a photo" do 
      expect{ Comment.create(:name => "Jimbob", :text => "Awesome!") }.to raise_error Mongoid::Errors::NoParent
    end
  end

  context "pass validations" do 
    xit "creates a comment" do
      expect(@photo.comments.create(name: 'Jimbob', text: 'Sweet!')).to be_an_instance_of Comment
    end
  end
end