require "spec_helper"

describe Photo do
  before :each do
    @contestant = build(:contestant)
    @photo = build(:photo, owner: @contestant)
  end

  describe "self.category?" do
    it "returns true for category in Photo::CATEGORIES and 'canada'" do
      %w{Flora FaUNa landscapes}.push(:Canada).each do |category|
        expect(Photo.category?(category)).to be true
      end
    end

    it "returns false for nils" do
      expect(Photo.category?(nil)).to be false
    end

    it "returns false for any other string" do
      %w{portmanteau sparrow tree spring}.each do |non_categories|
        expect(Photo.category?(non_categories)).to be false
      end
    end
  end

  context "fail validations" do
    it "must have a title" do
      @photo.unset :title
      expect { @photo.save! }.to raise_error Mongoid::Errors::Validations
    end

    it "must be in a category" do
      @photo.unset :category
      expect { @photo.save! }.to raise_error Mongoid::Errors::Validations
    end

    it "must be owned by a contestant" do
      @photo.save
      @photo.unset :owner
      expect { @photo.save! }.to raise_error Mongoid::Errors::Validations
    end
  end

  context "pass validations" do
    it "has optional description" do
      expect { @photo.save! }.to_not raise_error
      @photo.description = "So a clown walks into a bar..."
      expect { @photo.save! }.to_not raise_error
    end

    it "creates a photo" do
      expect(Photo.new).to be_an_instance_of Photo
    end

    it "creates a valid photo" do
      expect { @photo.save! }.to_not raise_error
    end
  end

  context "ownership" do
    it "has one owner" do
      expect(@photo.owner).to be_an_instance_of Contestant
    end

    it "has correct owner" do
      expect(@photo.owner).to be @contestant
    end

    it "is owned by the contestant" do
      expect(@photo.owner.entries).to include @photo
    end
  end

  context "#comments" do
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

  context "tags" do
    describe "#tagged?" do
      it "is false for tags not present" do
        expect(@photo.tagged? "pretty").to eql false
      end

      it "is true for present tags" do
        @photo.push tags: "silly"
        expect(@photo.tagged?("silly")).to eql true
      end
    end

    describe "#add_tag" do
      it "adds a tag" do
        @photo.add_tag "super-duper"
        expect(@photo.tags).to include("super-duper")
      end

      it "adds a tag only once" do
        legendary_tag = "legen-waitforit-dary"
        2.times { @photo.add_tag legendary_tag }

        legendary_tags = @photo.tags.select{ |t| t ==  legendary_tag }

        expect(legendary_tags.length).to eql 1
      end

      it "adds many tags" do
        expect {
          @photo.add_tag "stupendous"
          @photo.add_tag "snowy"
        }.to change { @photo.tags.length }.by 2
      end
    end
  end

  context "counts" do
    it "has 0 votes by default" do
      expect(@photo.votes).to eql 0
    end

    it "has 0 views by default" do
      expect(@photo.views).to eql 0
    end
  end

  context "category predicates" do
    it "canada?" do
      expect(build(:photo, tags: ["moose", "Canada"])).to be_canada
      expect(build(:photo, tags: ["beavers", "canada"])).to be_canada
    end

    it "for categories" do
      expect(build(:photo, category: :flora)).to be_flora
      expect(build(:photo, category: :fauna)).to be_fauna
      expect(build(:photo, category: :landscapes)).to be_landscapes
    end
  end

  describe "#original_key" do
    it "extracts the key of the photo from the AWS bucket url" do
      @photo.original_url = "https://s3.amazonaws.com/scbto-photos-originals/uploads%2F1397480083655-xr6m8ve8dajlwhfr-4cb837014b3c54440c778a3e47ed781f%2F100_1358.JPG"

      expect(@photo.original_key).to eql "uploads/1397480083655-xr6m8ve8dajlwhfr-4cb837014b3c54440c778a3e47ed781f/100_1358.JPG"
    end
  end

  describe "#aws_key" do
    it "returns a key for aws storage for different file sizes" do
      xs_key = @photo.id.to_s + "-xs"
      sm_key = @photo.id.to_s + "-sm"
      lg_key = @photo.id.to_s + "-lg"

      expect(@photo.aws_key(:xs)).to eql xs_key
      expect(@photo.aws_key(:sm)).to eql sm_key
      expect(@photo.aws_key(:lg)).to eql lg_key
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
    it "returns photo's inclusion in a category" do
      Photo::CATEGORIES.each do |category|
        next if category == :canada # canada determined by tags
        if @photo.category == category
          expect(@photo.send "#{category}?").to eql true
        else
          expect(@photo.send "#{category}?").to eql false
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
end
