require "spec_helper"

describe ContestsController do
  describe "POST :create" do
    context "without a current contest"
    context "with a current contest" do
      let!(:contest) { FactoryGirl.create :contest }

      before do
        post :create, FactoryGirl.build(:contest).attributes
      end

      it "does not create a contest" do
        expect(assigns[:contest]).to be_a_new_record
      end

      it "sets flash error" do
        expect(flash[:error]).not_to be_nil
      end

      it "re-renders :new" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET :new" do
    it "returns http success" do
      get :new
      expect(response).to be_success
    end
  end

  describe "GET :create" do
    it "returns http success" do
      get :create
      expect(response).to be_success
    end
  end
end
