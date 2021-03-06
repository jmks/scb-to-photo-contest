require 'spec_helper'

describe PhotosController do

  describe "GET index" do 
    before :each do 
      @photos = create_list :photo, 50
      @page_size = PhotosController::PHOTOS_PER_PAGE
    end

    it "assigns @gallery" do 
      get :index

      expect(assigns(:gallery)).to_not be_nil
    end

    context "when not filtering" do
      it "shows the most recent photos" do 
        get :index

        expected = Photo.recent.limit(@page_size).to_a
        actual   = assigns(:gallery).photos.to_a

        expect(actual).to eql expected
      end
    end

    context "when filtering by named category" do 
      it "show most recent :flora photos" do 
        get :index, category: "flora"

        expected = Photo.flora.recent.limit(@page_size).to_a
        actual   = assigns(:gallery).photos.to_a

        expect(actual).to eql expected
      end

      it "show most recent :fauna photos" do 
        get :index, category: "fauna"

        expected = Photo.fauna.recent.limit(@page_size).to_a
        actual   = assigns(:gallery).photos.to_a

        expect(actual).to eql expected
      end

      it "show most recent :landscapes photos" do 
        get :index, category: "landscapes"

        expected = Photo.landscapes.recent.limit(@page_size).to_a
        actual   = assigns(:gallery).photos.to_a

        expect(actual).to eql expected
      end

      it "show most recent :canada photos" do 
        get :index, category: "canada"

        expected = Photo.canada.recent.limit(@page_size).to_a
        actual   = assigns(:gallery).photos.to_a

        expect(actual).to eql expected
      end
    end

    context "when filtering by popularity" do 
      it "shows most highly viewed photos" do 
        get :index, popular: :views

        expected = Photo.most_viewed.recent.limit(@page_size).to_a
        actual   = assigns(:gallery).photos.to_a

        expect(actual).to eql expected 
      end

      it "shows most highly voted photos" do
        get :index, popular: :votes

        expected = Photo.most_voted.recent.limit(@page_size).to_a
        actual   = assigns(:gallery).photos.to_a

        expect(actual).to eql expected
      end
    end

    context "when filtering by tags" do 
      it "shows the most recent tagged photos" do
        tag = "canada"
        get :index, tag: tag

        expected = Photo.tagged(tag).limit(@page_size).to_a
        actual   = assigns(:gallery).photos.to_a

        expect(actual).to eql expected
      end
    end

    context "when filtering by contestant" do 
      it "shows the contestant's photos" do 
        contestant = @photos.to_a.sample.owner

        get :index, contestant_id: contestant.id

        expected = contestant.entries.desc(:created_at).to_a
        actual   = assigns(:gallery).photos.to_a

        expect(actual).to eql expected
      end
    end
  end
end
