require "spec_helper"

describe Photo do
  describe ".category?" do
    context "when a category" do
      it "returns true" do
        %w{Flora FaUNa landscapes}.each do |category|
          expect(Photo.category?(category)).to be true
        end
      end
    end

    context "when 'canada'" do
      it "returns true" do
        expect(Photo.category?("Canada")).to be true
      end
    end

    context "when anything else" do
      it "returns false" do
        %w{portmanteau sparrow tree spring}.each do |non_category|
          expect(Photo.category?(non_category)).to be false
        end

        expect(Photo.category?(nil)).to be false
      end
    end
  end

  describe "validations" do
    context "without a title" do
      let(:photo) { build :photo, title: nil }

      it "is not valid" do
        expect(photo).to_not be_valid
      end

      it "has title error" do
        photo.valid?

        expect(photo.errors).to include :title
      end
    end

    context "without a category" do
      let(:photo) { build :photo, category: nil }

      it "is not valid" do
        expect(photo).to_not be_valid
      end

      it "has category error" do
        photo.valid?

        expect(photo.errors).to include :category
      end
    end

    context "without a category" do
      let(:photo) { build :photo, owner: nil }

      it "is not valid" do
        expect(photo).to_not be_valid
      end

      it "has owner error" do
        photo.valid?

        expect(photo.errors).to include :owner
      end
    end

    describe "optional description" do
      context "with description present" do
        let(:photo) { build :photo }

        it "is valid" do
          expect(photo).to be_valid
        end
      end

      context "with blank description" do
        let(:photo) { build :photo, description: "" }

        it "is valid" do
          expect(photo).to be_valid
        end
      end
    end
  end

  context "#owner" do
    let(:contestant) { build :contestant }
    let(:photo)      { build :photo, owner: contestant }

    it "is a contestant" do
      expect(photo.owner).to be_an_instance_of Contestant
    end

    it "has correct owner" do
      expect(photo.owner).to be contestant
    end
  end

  describe "#tagged?" do
    context "when photo tagged 'awesomesauce'" do
      let(:photo) { build :photo, tags: ["awesomesauce"] }

      it "returns true" do
        expect(photo.tagged?("awesomesauce")).to be true
      end
    end

    context "when photo not tagged 'awesomesauce'" do
      let(:photo) { build :photo }

      it "returns false" do
        expect(photo.tagged?("awesomesauce")).to be false
      end
    end
  end

  describe "#add_tag" do
    let(:photo) { build :photo }

    it "adds a tag" do
      photo.add_tag "super-duper"
      expect(photo.tags).to include("super-duper")
    end

    it "adds a tag only once" do
      legendary_tag = "legen-waitforit-dary"

      photo.add_tag legendary_tag

      expect {
        photo.add_tag legendary_tag
      }.to_not change {
        photo.tags.count { |tag| tag == legendary_tag }
      }
    end

    it "adds many tags" do
      expect {
        photo.add_tag "stupendous"
        photo.add_tag "snowy"
      }.to change { photo.tags.length }.by 2
    end
  end

  describe "#votes" do
    let(:photo) { build :photo }

    context "when new" do
      it "is 0" do
        expect(photo.votes).to eql 0
      end
    end
  end

  describe "#views" do
    let(:photo) { build :photo }

    context "when new" do
      it "is 0" do
        expect(photo.views).to eql 0
      end
    end
  end

  describe "#original_key" do

    context "when empty" do
      let(:photo) { build :photo }

      it "returns blank string" do
        expect(photo.original_key).to be_blank
      end
    end

    context "with an original url" do
      let(:photo) { build :photo, original_url: "https://s3.amazonaws.com/scbto-photos-originals/uploads%2F1397480083655-xr6m8ve8dajlwhfr-4cb837014b3c54440c778a3e47ed781f%2F100_1358.JPG" }

      it "returns the AWS bucket key" do
        bucket_key = "uploads/1397480083655-xr6m8ve8dajlwhfr-4cb837014b3c54440c778a3e47ed781f/100_1358.JPG"

        expect(photo.original_key).to eql bucket_key
      end
    end
  end

  describe "#aws_key" do
    let(:photo) { build :photo }

    it "returns '<photo.id>-xs' for :xs" do
      expect(photo.aws_key(:xs)).to eql "#{photo.id}-xs"
    end

    it "returns '<photo.id>-sm' for :sm" do
      expect(photo.aws_key(:sm)).to eql "#{photo.id}-sm"
    end

    it "returns '<photo.id>-lg' for :lg" do
      expect(photo.aws_key(:lg)).to eql "#{photo.id}-lg"
    end
  end

  describe "#registration_status" do
    context "with photo details" do
      let(:photo) { build(:photo) }

      it "is submitted" do
        expect(photo.registration_status).to be :submitted
      end
    end

    context "with an original_url" do
      let(:photo) { build(:photo, original_url: "http://location-in-the-cloud") }

      it "is uploaded" do
        expect(photo.registration_status).to be :uploaded
      end

      context "with an order number" do
        let(:photo) { build(:photo, original_url: "http://location-in-the-cloud", order_number: 12345678) }

        it "is printed" do
          expect(photo.registration_status).to be :printed
        end
      end

      context "when submission is complete" do
        let(:photo) do
          build :photo,
                original_url: "http://location-in-the-cloud",
                submission_complete: true
        end

        it "is confirmed" do
          expect(photo.registration_status).to be :confirmed
        end
      end
    end
  end

  describe "category predicate methods" do
    context "when photo in category" do
      it "returns true" do
        expect(build(:photo, category: :flora)).to be_flora
        expect(build(:photo, category: :fauna)).to be_fauna
        expect(build(:photo, category: :landscapes)).to be_landscapes
      end
    end

    context "when photo not in category" do
      it "returns false" do
        expect(build(:photo, category: :fauna)).to_not be_flora
        expect(build(:photo, category: :landscapes)).to_not be_fauna
        expect(build(:photo, category: :flora)).to_not be_landscapes
      end
    end
  end

  describe "#canada?" do
    context "when photo tagged 'Canada'" do
      let(:photo) { build :photo, tags: %w{Canada} }

      it "returns true" do
        expect(photo.canada?).to be true
      end
    end

    context "when photo tagged 'canada'" do
      let(:photo) { build :photo, tags: %w{canada} }

      it "returns true" do
        expect(photo.canada?).to be true
      end
    end

    context "when photo not tagged 'Canada' or 'canada'" do
      let(:photo) { build :photo, tags: [] }

      it "returns false" do
        expect(photo.canada?).to be false
      end
    end
  end
end
