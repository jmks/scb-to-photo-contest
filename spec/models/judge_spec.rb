require 'spec_helper'

describe Judge do
  before :all do
    @max_per_category = ContestRules::JUDGING_SHORTLIST_MAX_PER_CATEGORY
    @categories       = Photo::CATEGORIES
  end

  describe 'multiple judges' do
    it 'can shortlist the same photo' do
      photo  = build :photo, category: :canada
      judges = build_list :judge, 3

      judges.each do |j|
        j.shortlist_photo photo
      end
      judges_shortlisted_photo = judges.map{|j| j.canada_shortlist.include?(photo) }.all?

      expect(judges_shortlisted_photo).to eql true
    end
  end

  describe '#shortlist_photo' do
    before :each do
      @photos = build_list :photo, 5
      @judge  = build :judge
    end

    it 'adds a photo' do
      photo = @photos.first

      @judge.shortlist_photo photo

      expect(@judge.send("#{ photo.category.to_s }_shortlist").length).to eql 1
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

    # this is too category-specific
    it 'adds canada photo' do
      expect {
        @judge.shortlist_photo(@photos.first, :canada)
      }.to change { @judge.canada_shortlist.length }.by(1)
    end

    it 'adds many photos' do
      @photos.each { |photo| @judge.shortlist_photo photo }

      expected_photos = @photos.map(&:category)
                               .group_by{ |c| c }
                               .map{ |k, v| [v.length, @max_per_category].min }
                               .inject(0, :+)

      expect(
        @categories.map do |cat|
          @judge.send("#{ cat.to_s }_shortlist").length
        end.inject(0, :+)
      ).to eql expected_photos
    end

    it "doesn't add photos beyond the maximum per category" do
      build_list(:photo, @max_per_category, category: :flora).each do |p|
        @judge.shortlist_photo p
      end

      expect(@judge.shortlist_photo(build(:photo, category: :flora))).to eql false
    end
  end

  describe '#remove_photo_from_shortlist' do
    before :each do
      @photos = build_list(:photo, 5).uniq
      @judge = build :judge
      @photos.each { |p| @judge.shortlist_photo(p) }
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

  describe '#shortlist_done?' do

  end

  # this isn't a method...
  describe '#shortlist_complete' do
    it 'is false for new judges' do
      judge = build :judge

      expect(judge.shortlist_complete).to eql false
    end

    it 'is false when each category does not have length JUDGING_SHORTLIST_MAX_PER_CATEGORY' do
      # otherwise test could not pass with non-empty shortlist_photos
      expect(@categories.length).to be > 1
      expect(@max_per_category).to be > 1

      judge = build :judge
      photo = build :photo

      judge.shortlist_photo photo

      expect(judge.shortlist_complete).to eql false
    end

    it 'is true when each category shortlist is full' do
      judge = build(:judge)

      @categories.each do |cat|
        @max_per_category.times do
          category_photo = build(:photo, category: cat)

          judge.shortlist_photo(category_photo, cat)
        end
      end

      expect(judge.shortlist_complete).to eql true
    end
  end

  describe 'self.shortlist_by_category' do
    context 'when no shortlisted photos' do
      it 'returns hash of categories to empty lists' do
        empty_arrs = Photo::CATEGORIES.map{ |c| Array.new }
        empty_category_hash = Hash[Photo::CATEGORIES.zip(empty_arrs)]

        expect(Judge.shortlist_by_category).to eql empty_category_hash
      end
    end

    context 'when some photos shortlisted' do
      it 'returns a map of category to photos shortlisted in that category' do
        photos = build_list :photo, 5
        judges = create_list :judge, 5

        (0...5).each do |i|
          judges[i].shortlist_photo(photos[i])
        end

        expected = photos.group_by{ |p| p.category }
        # augment will possibly missing categories
        @categories.each do |cat|
          expected[cat] = [] unless expected[cat]
        end
        actual = Judge.shortlist_by_category

        # match keys and element ids
        expect(expected.keys).to match_array actual.keys
        expected.each_key do |category|
          expect(expected[category].map(&:id)).to match_array actual[category].map(&:id)
        end
      end
    end
  end

  describe "#current_contest" do
    let(:contest) { create :contest }
    let(:judge)   { create :judge }

    subject { judge }

    context "when judge is not assigned the current contest" do
      it "returns nil" do
        expect(subject.current_contest).to be_nil
      end
    end

    context "when judge is assigned to the current contest" do
      it "returns true" do
        judge.contests << contest
        expect(subject.current_contest).to eql contest
      end
    end
  end

  describe "#nominations_complete?" do
    let! (:contest)  { create :contest }
    let! (:judge)    { create :judge, contests: [contest] }
    let  (:category) { Photo::CATEGORIES.sample }

    subject { judge }

    context "when nominations are not complete" do
      it "returns false" do
        expect(subject).to_not be_nominations_complete
      end

      it "returns false for specific categories" do
        expect(subject.nominations_complete?(category)).to be false
      end
    end

    context "when nominations are partially complete" do
      it "returns true for nominee filled categories" do
        contest.nominees_per_category.times do
          photo = create(:photo, contest: contest)
          judge.nominees.create(photo: photo, judge: judge, category: category)
        end

        expect(subject.nominations_complete?(category)).to be true
      end
    end

    context "when nominations are complete" do
      it "returns true" do
        Photo::CATEGORIES.each do |category|
          contest.nominees_per_category.times do
            photo = create(:photo, contest: contest)
            judge.nominees.create(photo: photo, judge: judge, category: category)
          end
        end

        expect(subject).to be_nominations_complete
        Photo::CATEGORIES.each do |category|
          expect(subject.nominations_complete?(category)).to be true
        end
      end
    end
  end

  describe "#category_nominees" do
    let(:judge)    { create :judge }
    let(:category) { Photo::CATEGORIES.sample }

    context "when no nominees" do
      it "returns an empty relation" do
        expect(subject.category_nominees(category)).to be_empty
      end
    end

    context "when there are nominees" do
      it "returns nominees in a given category" do
        nominating_judge = judge
        nominee          = build(:nominee, judge: nominating_judge, category: category)
        nominating_judge.nominees << nominee

        expect(nominating_judge.category_nominees(category)).to eql [nominee]
      end
    end
  end
end
