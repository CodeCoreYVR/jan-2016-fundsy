class CampaignsController < ApplicationController
  before_action :authenticate_user, only: [:destroy]
  before_action :find_campaign, only: [:show, :edit, :update]

  def new
    @campaign = Campaign.new
  end

  def hello

  end

  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.user = current_user

    if @campaign.save
      flash[:notice] = "Campaign created!"
      redirect_to campaign_path(@campaign)
    else
      flash[:alert] = "Campaign not created!"
      render :new
    end
  end

  def show
    # render :show
  end

  def index
    @campaigns = Campaign.order("created_at ASC")
  end

  def edit
  end

  def update
    # we need to force the slug to be nil before updating it in order to have
    # FriendlyId generate a new slug for us. We're using `history` option with
    # FriendlyId so old urls will still work.
    @campaign.slug = nil
    if @campaign.update campaign_params
      redirect_to campaign_path(@campaign), notice: "Campaign updated!"
    else
      flash[:alert] = "Campaign not updated!"
      render :edit
    end
  end

  def destroy
    user_campaign.destroy
    redirect_to campaigns_path, notice: "Campaign deleted!"
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :goal, :description, :end_date)
  end

  def find_campaign
    @campaign = Campaign.friendly.find params[:id]
  end

  def user_campaign
    @user_campaign ||= current_user.campaigns.friendly.find params[:id]
  end
end
