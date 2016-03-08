require "spec_helper"

describe ContestsController do
  context "without admin privledges" do
    it "redirects" do
      post_new_contest
      expect(response).to be_a_redirect
    end
  end

  context "when an admin" do
    before { sign_in FactoryGirl.create(:admin) }

    describe "POST :create" do
      context "without a current contest" do
        it "creates a new contest" do
          expect {
            post_new_contest
          }.to change {
            Contest.count
          }.from(0).to 1
        end

        it "sets flash messge" do
          post_new_contest
          expect(flash[:alert]).not_to be_nil
        end
      end

      context "with a current contest" do
        let!(:contest) { FactoryGirl.create :contest }

        before { post_new_contest }

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
      before { get :new }

      it "returns http success" do
        expect(response).to be_success
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
  end

  def post_new_contest
    post :create, contest: FactoryGirl.build(:contest).attributes
  end
end
