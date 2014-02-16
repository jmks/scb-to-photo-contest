require 'spec_helper'

describe Comment do 

  before :each do 
    @contestant = create(:contestant)
    @photo = create(:photo, owner: @contestant)
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
    before :each do 
      @comment = @photo.comments.create(name: 'Jimbob', text: 'Sweet!')
    end

    it "creates a comment for saved photos" do
      expect(@comment).to be_an_instance_of Comment
      expect(@photo.comments.length).to eql 1
    end
  end
end