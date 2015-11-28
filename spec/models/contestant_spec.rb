require 'spec_helper'

describe Contestant do
  describe "validations" do
    context "without an email address" do
      let(:contestant) { build :contestant, email: nil }

      it "is not valid" do
        expect(contestant).to_not be_valid
      end

      it "has email error" do
        contestant.valid?

        expect(contestant).to have_error :email
      end
    end

    context "with duplicate email address" do
      let!(:other)     { create :contestant }
      let(:contestant) { build :contestant, email: other.email }

      it "is not valid" do
        expect(contestant).to_not be_valid
      end

      it "has email error" do
        contestant.valid?
        expect(contestant).to have_error :email
      end
    end

    context "with bad email format" do
      let(:contestant) { build :contestant }

      it "is not valid" do
        bad_emails = %w{bademail.com chunkeymonkey@gmail @tenderlove.io eg@.com}

        bad_emails.each do |email|
          contestant.email = email

          expect(contestant).to_not be_valid
          expect(contestant).to have_error :email
        end
      end
    end

    context "without first name" do
      let(:contestant) { build :contestant, first_name: nil }

      it "is not valid" do
        expect(contestant).to_not be_valid
      end

      it "is not valid" do
        contestant.valid?

        expect(contestant).to have_error :first_name
      end
    end

    context "without last name" do
      let(:contestant) { build :contestant, last_name: nil }

      it "is not valid" do
        expect(contestant).to_not be_valid
      end

      it "is not valid" do
        contestant.valid?

        expect(contestant).to have_error :last_name
      end
    end
  end

  describe '#vote_for' do
    let(:contestant) { create :contestant }
    let(:photo)      { create :photo }

    before do
      contestant.vote_for photo
    end

    it "tracks photos voted for" do
      expect(contestant.voted_photo_ids).to include(photo.id)
    end

    it "tracks photos voted for once" do
      2.times { contestant.vote_for photo }

      expect(contestant.voted_photo_ids.select { |id| id == photo.id }.length).to eql 1
    end

    it "tracks multiple photos" do
      contestant.vote_for build(:photo)

      expect(contestant.voted_photo_ids.length).to eql 2
    end
  end

  describe "#entries_left?" do
    let(:contest) { build :contest, entries_per_contestant: 3 }

    context "with fewer entries than contest allows" do
      let(:contestant) do
        contestant = create :contestant
        build_list :photo, 2, owner: contestant
        contestant
      end

      it "returns true" do
        expect(contestant.entries_left?).to be true
      end
    end

    context "with equal entries that contest allows" do
      let(:contestant) do
        contestant = create :contestant
        build_list :photo, contest.entries_per_contestant, owner: contestant
        contestant
      end

      it "returns false" do
        pending("A contestant is not associated with a particular contest yet")
        expect(contestant.entries_left?).to be false
      end
    end
  end
end
