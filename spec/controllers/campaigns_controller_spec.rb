require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  describe "#new" do
    it "renders the new template" do
      # This mimics sending a get request to the new action
      get :new
      # response is an object that is given to us by RSpec that will help test
      # things like redirect / render
      # render_template is a an RSpec (rspec-rails) matcher that help us check
      # if the controller renders the template with the given name.
      expect(response).to render_template(:new)
    end

    it "instantiates a new Campaign object and sets it to @campaign" do
      get :new
      expect(assigns(:campaign)).to be_a_new(Campaign)
    end
  end

  describe "#create" do
    context "with valid attributes" do
      def valid_request
        post :create, campaign: {name: "some valid name",
          description: "some valid description",
          goal: 1000000
        }
      end
      it "creates a record in the database" do
        campaign_count_before = Campaign.count
        valid_request
        campaign_count_after  = Campaign.count
        expect(campaign_count_after - campaign_count_before).to eq(1)
      end

      it "redirects to the campaign show page" do
        valid_request
        expect(response).to redirect_to(campaign_path(Campaign.last))
      end

      it "sets a flash notice message" do
        valid_request
        expect(flash[:notice]).to be
      end
    end
    context "with invalid attributes" do
      it "doesn't create a record in the database"
      it "renders the new template"
      it "sets a flash alert message"
    end
  end

end
