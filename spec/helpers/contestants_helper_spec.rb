require 'spec_helper'

describe AlertHelper, type: :helper do
  describe "#next_action" do
    def photo_stub status
      photo = Photo.new
      allow(photo).to receive(:registration_status) { status }
      photo
    end

    it "returns a link to the photo upload page for submitted photos" do
      submitted = photo_stub(:submitted)

      result = helper.next_action(submitted)
      expect(result.starts_with?("<a")).to be true
      expect(result).to include new_photo_entry_path(photo_id: submitted.id)
    end

    it "returns a link to the order path for uploaded photos" do
      uploaded = photo_stub(:uploaded)

      result = helper.next_action(uploaded)
      expect(result.starts_with?("<a")).to be true
      expect(result).to include order_path
    end

    it "returns the printed message for printed photos" do
      printed = photo_stub(:printed)

      expect(helper.next_action(printed)).to eql Photo::Registration_Message[:printed]
    end

    it "returns the confirmed message for confirmed photos" do
      confirmed = photo_stub(:confirmed)

      expect(helper.next_action(confirmed)).to eql Photo::Registration_Message[:confirmed]
    end
  end
end
