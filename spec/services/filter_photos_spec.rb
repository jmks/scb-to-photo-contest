require "spec_helper"

describe FilterPhotos do 

  before :each do 
    @photos = create_list :photo, 20
    @contestant = @photos.sample.owner

    @params = {
      contestant_id: @contestant.id,
      tag: @photos.sample.tags.sample,
      category: Photo::CATEGORIES.sample.to_s,
    }
  end

  # TODO: add mongoid-rspec gem to fix matchers not matching
  # on expect(Mongoid::Criteria).to eql Mongoid::Criteria

  context "when :contestant_id is present" do
    it "filters by contestant" do
      photo_filter = FilterPhotos.new(@params).call

      expect(photo_filter.filter).to eql :contestant
      expect(photo_filter.title).to  eql @contestant.public_name
      expect(photo_filter.photos == @contestant.entries).to be true
    end
  end

  context "when :tag is present" do 
    it "filters by tag" do 
      params = @params.except(:contestant_id)
      photo_filter = FilterPhotos.new(params).call

      expect(photo_filter.filter).to eql :tag
      expect(photo_filter.title).to eql params[:tag].titleize
      expect(photo_filter.photos == Photo.tagged(params[:tag])).to be true
    end
  end

  context "when :category is present" do 
    it "filters by category" do 
      params = @params.except(:contestant_id, :tag)
      photo_filter = FilterPhotos.new(params).call

      expect(photo_filter.filter).to eql params[:category].to_sym
      expect(photo_filter.title).to eql params[:category].titleize
      expect(photo_filter.photos == Photo.category(params[:category])).to be true
    end

    it "'canada' used as a category" do 
      params = @params.except(:contestant_id, :tag)
      params[:category] = "canada"
      photo_filter = FilterPhotos.new(params).call

      expect(photo_filter.filter).to eql :canada
      expect(photo_filter.title).to eql "Canada"
      expect(photo_filter.photos == Photo.canada).to be true
    end
  end

  context "when :popular is present" do 
    it "filters by votes" do 
      params = { popular: "votes" }
      photo_filter = FilterPhotos.new(params).call

      expect(photo_filter.filter).to eql :votes
      expect(photo_filter.title).to eql "Votes"
      expect(photo_filter.photos == Photo.most_voted).to be true
    end
  end

  it "by default users all photos" do 
    photo_filter = FilterPhotos.new().call

    expect(photo_filter.filter).to eql :all
    expect(photo_filter.title).to eql "All"
    expect(photo_filter.photos ==Photo.all).to be true
  end
end