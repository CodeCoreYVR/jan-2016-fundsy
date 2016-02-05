require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do

  let(:campaign) { FactoryGirl.create(:campaign) }
  # def campaign
  #   @campaign ||= FactoryGirl.create(:campaign)
  # end

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
    before do
      get :edit, id: campaign
    end

    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end

    it "finds the campaign by id and sets it to @campaign instance variable" do
      expect(assigns(:campaign)).to eq(campaign)
    end
  end

  describe "#update" do
    context "with valid attributes" do
      before do
        # GIVEN:
        # We need to have a campaign created in the DB.
        # We can make use of the `campaign` variable we defined using `let`
        # at the top

        # WHEN:
        patch :update, id: campaign.id, campaign: {name: "new valid name"}
      end

      it "updates the records with new parameter(s)" do
        # THEN:
        # We must use campaign.reload in this scenario because the controller
        # will instantiate another campaign object based on the id but it will
        # live in another memory location. Which means `campaign` here will still
        # have the old data not the possibly updated one. Reload will make
        # ActiveRecord rerun the query and fetches the information from the DB
        # again.
        expect(campaign.reload.name).to eq("new valid name")
      end

      it "redirects to the campaign show page" do
        expect(response).to redirect_to(campaign_path(campaign))
      end

      it "sets a flash notice message" do
        expect(flash[:notice]).to be
      end
    end
    context "with invalid attributes" do
      it "doesn't update the record" do
        goal_before = campaign.goal
        patch :update, id: campaign.id, campaign: {goal: 6}
        expect(campaign.reload.goal).to eq(goal_before)
      end

      it "renders the edit template" do
        patch :update, id: campaign.id, campaign: {goal: 6}
        expect(response).to render_template(:edit)
      end

      it "sets a flash alert message" do
        patch :update, id: campaign.id, campaign: {goal: 6}
        expect(flash[:alert]).to be
      end
    end
  end

  describe "#destroy" do
    # let!(:campaign) { FactoryGirl.create(:campaign) }

    it "removes the campaign from the database" do
      # campaign
      # expect { delete :destroy, id: campaign.id }.to change { Campaign.count }.by(-1)

      campaign # will will create the campaign
      count_before = Campaign.count
      delete :destroy, id: campaign.id
      count_after = Campaign.count
      expect(count_before - count_after).to eq(1)
    end

    it "redirects to the campaign index page" do
      delete :destroy, id: campaign.id
      expect(response).to redirect_to(campaigns_path)
    end

    it "Sets a flash message" do
      delete :destroy, id: campaign.id
      expect(flash[:notice]).to be
    end
  end

end
