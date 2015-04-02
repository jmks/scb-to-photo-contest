require 'spec_helper'

describe PhotosController do

  describe "GET index" do 
    before :all do 
      build_list :photo, 50
      @page_size = PhotosController::PHOTOS_PER_PAGE
    end

    it "assigns @photos" do 
      get :index

      expect(assigns(:photos)).to_not be_nil
    end

    it "assigns @title" do 
      get :index

      expect(assigns(:title)).to_not be_nil
    end

    context "when not filtering" do
      it "shows the most recent photos" do 
        get :index

        expected = Photo.recent.limit(@page_size).to_a
        expect(assigns(:photos).to_a).to eql expected
      end
    end

    context "when filtering by named category" do 
      it "show most recent :flora photos" do 
        get :index, category: "flora"

        expected = Photo.flora.recent.limit(@page_size).to_a
        expect(assigns(:photos).to_a).to eql expected
      end

      it "show most recent :fauna photos" do 
        get :index, category: "fauna"

        expected = Photo.fauna.recent.limit(@page_size).to_a
        expect(assigns(:photos).to_a).to eql expected
      end

      it "show most recent :landscapes photos" do 
        get :index, category: "landscapes"

        expected = Photo.landscapes.recent.limit(@page_size).to_a
        expect(assigns(:photos).to_a).to eql expected
      end

      it "show most recent :canada photos" do 
        get :index, category: "canada"

        expected = Photo.canada.recent.limit(@page_size).to_a
        expect(assigns(:photos).to_a).to eql expected
      end
    end

    context "when filtering by popularity"
    context "when filtering by tags" do 
      it "shows the most recent tagged photos" do
        tag = "canada"
        get :index, tag: tag

        expected = Photo.tagged(tag).limit(@page_size).to_a
        expect(assigns(:photos).to_a).to eql expected
      end
    end
  end
end
