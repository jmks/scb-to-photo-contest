require 'spec_helper'

describe Judge do

  describe '#shortlist_photo' do
    before :all do 
      @max_per_category = ContestRules::JUDGING_SHORTLIST_MAX_PER_CATEGORY
      @categories = Photo::CATEGORIES + [:canada]
    end

    before :each do 
      @photos = build_list :photo, 5
      @judge = build :judge
    end

    it 'adds a photo' do 
      @judge.shortlist_photo @photos.first

      expect(@judge.send("#{ @photos.first.category.to_s }_shortlist_ids").length).to eql 1
    end

    it 'adds canada photo' do 
      expect {
        @judge.shortlist_photo(@photos.first, :canada)
      }.to change { @judge.canada_shortlist_ids.length }.by(1)
    end

    it 'adds many photos' do 
      @photos.each { |photo| @judge.shortlist_photo photo }

      expect(
        @categories.map do |cat|
          @judge.send("#{ cat.to_s }_shortlist_ids").length
        end.inject(0, :+)
      ).to eql @photos.length
    end

    it "doesn't add photos beyond the maxiumn per category" do 
      build_list(:photo, @max_per_category, category: :flora).each do 
        |p| @judge.shortlist_photo p
      end

      expect(@judge.shortlist_photo(build(:photo, category: :flora))).to eql false
    end
  end
end
