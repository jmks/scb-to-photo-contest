require 'spec_helper'

describe Comment do

  describe "new" do
    let(:contestant) { create(:contestant) }
    let(:photo)      { create(:photo, owner: contestant) }
    let(:comment)    { create(:comment, photo: photo) }

    context "when invalid" do
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

    it "is valid" do
      expect(comment).to be_an_instance_of Comment
      expect(comment).to be_valid
    end
  end

  describe "self.reported" do
    let(:reported_comments) { create_list(:comment, 5, reported: true) }

    it "when there are no reported comments returns none" do
      expect(Comment.reported).to be_empty
    end

    it "returns reported comments" do
      reported_comments

      expect(Comment.reported).to eql reported_comments
    end
  end
end
