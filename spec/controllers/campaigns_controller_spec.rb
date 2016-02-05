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
      def invalid_request
        post :create, campaign: {name: "some valid name",
          description: "some valid description",
          goal: 5
        }
      end
      it "doesn't create a record in the database" do
        campaign_count_before = Campaign.count
        invalid_request
        campaign_count_after = Campaign.count
        expect(campaign_count_before).to eq(campaign_count_after)
      end

      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end

      it "sets a flash alert message" do
        invalid_request
        expect(flash[:alert]).to be
      end
    end
  end

  describe "#show" do
    before do
      # GIVEN:
      @campaign = Campaign.create({name: "valid name",
        description: "valid description",
        goal: 100000})
      # WHEN:
      get :show, id: @campaign.id
    end

    it "finds the object by its id and sets to to @campaign variable" do
      # THEN:
      expect(assigns(:campaign)).to eq(@campaign)
    end

    it "renders the show template" do
      # THEN:
      expect(response).to render_template(:show)
    end

    it "raises an error if the id passed doesn't match a record in the DB" do
      expect { get :show, id: 2423424234324 }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  describe "#index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "fetches all records and assigns them to @campaigns" do
      # GIVEN:
      c  = FactoryGirl.create(:campaign)
      c1 = FactoryGirl.create(:campaign)
      # WHEN:
      get :index
      # THEN:
      expect(assigns(:campaigns)).to eq([c, c1])
    end
  end

  describe "#edit" do
    it "renders the edit template"
    it "finds the campaign by id and sets it to @campaign instance variable"
  end

end
