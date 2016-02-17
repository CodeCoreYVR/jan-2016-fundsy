require 'rails_helper'

RSpec.describe PledgesController, type: :controller do
  let(:user)     { FactoryGirl.create(:user) }
  let(:campaign) { FactoryGirl.create(:campaign) }

  describe "#create" do
    context "with no signed in user" do
      it "redirects to the sign in page" do
        post :create, campaign_id: campaign.id,
                      pledge: FactoryGirl.attributes_for(:pledge)
        expect(response).to redirect_to new_session_path
      end
    end

    context "with signed in user" do
      before { signin(user) }

      context "with valid params" do
        def send_valid_request
          post :create, campaign_id: campaign.id,
                        pledge: FactoryGirl.attributes_for(:pledge)
        end

        it "creates a pledge in the database associated with the campaign" do
          count_before = campaign.pledges.count
          send_valid_request
          count_after = campaign.pledges.count
          expect(count_after - count_before).to eq(1)
        end

        it "associates the pledge with the logged in user" do
          send_valid_request
          expect(Pledge.last.user).to eq(user)
        end

        it "redirects to the campaign show page"
        it "sets a flash notice messages"
      end

      context "with invalid params" do

      end
    end
  end


end
