require 'spec_helper'

describe PhotoGallery do 
  before :each do 
    @photos = create_list :photo, 31
  end

  describe "#total_pages" do 
    it "should have 3 pages" do 
      gallery = PhotoGallery.new(Hash.new, FilterPhotos.new.call)

      expect(gallery.total_pages).to eql 3
    end
  end

  describe "#next_params" do 
    it "should contain an incremented page value" do 
      gallery = PhotoGallery.new(Hash.new, FilterPhotos.new.call)

      expect(gallery.next_params).to have_key :page
      expect(gallery.next_params[:page]).to eql 2
    end
  end
end