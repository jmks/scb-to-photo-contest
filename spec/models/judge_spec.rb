require 'spec_helper'

describe Judge do

  describe 'multiple judges' do 
    it 'can shortlist a photo' do 
      photo = build(:photo, category: :canada)
      a, b = build(:judge), build(:judge)

      a.shortlist_photo(photo, :canada)
      b.shortlist_photo(photo, :canada)

      expect(a.canada_shortlist.include? photo).to eql true
      expect(b.canada_shortlist.include? photo).to eql true
    end
  end

  describe '#shortlist_photo' do
    before :all do 
      @max_per_category = ContestRules::JUDGING_SHORTLIST_MAX_PER_CATEGORY
      @categories = Photo::CATEGORIES
    end

    before :each do 
      @photos = build_list :photo, 5
      @judge = build :judge
    end

    it 'adds a photo' do 
      @judge.shortlist_photo @photos.first

      expect(@judge.send("#{ @photos.first.category.to_s }_shortlist").length).to eql 1
    end

    it 'adds a photo to only one category' do 
      @judge.shortlist_photo @photos.first

      expect(
        @categories.map do |cat|
          @judge.send("#{ cat.to_s }_shortlist").length
        end.inject(0, :+)
      ).to eql 1
    end

    it 'does not add same photo twice' do 
      2.times { @judge.shortlist_photo @photos.first }
      expect(@judge.send("#{ @photos.first.category.to_s }_shortlist").length).to eql 1
    end

    it 'adds canada photo' do 
      expect {
        @judge.shortlist_photo(@photos.first, :canada)
      }.to change { @judge.canada_shortlist.length }.by(1)
    end

    it 'adds many photos' do 
      @photos.each { |photo| @judge.shortlist_photo photo }

      expect(
        @categories.map do |cat|
          @judge.send("#{ cat.to_s }_shortlist").length
        end.inject(0, :+)
      ).to eql @photos.length
    end

    it "doesn't add photos beyond the maximum per category" do 
      build_list(:photo, @max_per_category, category: :flora).each do |p| 
        @judge.shortlist_photo p
      end

      expect(@judge.shortlist_photo(build(:photo, category: :flora))).to eql false
    end
  end

  describe '#remove_photo_from_shortlist' do 
    before :all do 
      @categories = Photo::CATEGORIES
    end

    before :each do 
      @photos = build_list(:photo, 5).uniq # TODO: make photos unique!
      @judge = build :judge
      @photos.each { |p| @judge.shortlist_photo(p, p.category) }
    end

    it 'removes a photo' do 
      expect(@judge.remove_photo_from_shortlist(@photos.first, @photos.first.category)).to eql true
    end

    it 'only removes a single photo' do 
      expect {
        @judge.remove_photo_from_shortlist(@photos.first, @photos.first.category)
        }.to change { 
          @categories.map do |cat|
            @judge.send("#{ cat.to_s }_shortlist").length
          end.inject(0, :+)
        }.by(-1)
    end
  end

  describe '#shortlist_complete' do 
    it 'is true when full photo selection complete' do 
      photo_count = ContestRules::JUDGING_SHORTLIST_MAX_PER_CATEGORY
      judge = build(:judge)

      Photo::CATEGORIES.each do |cat|
        photo_count.times { judge.shortlist_photo(build(:photo, category: cat), cat) }
      end

      expect(judge.shortlist_complete).to eql true
    end
  end
end
