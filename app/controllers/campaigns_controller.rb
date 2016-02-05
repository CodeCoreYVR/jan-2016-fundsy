class CampaignsController < ApplicationController

  def new
    @campaign = Campaign.new
  end

  def create
    campaign_params = params.require(:campaign).permit(:name, :goal, :description, :end_date)
    @campaign = Campaign.create(campaign_params)
    if @campaign.valid?
      flash[:notice] = "Campaign created!"
      redirect_to campaign_path(@campaign)
    else
      flash[:alert] = "Campaign not created!"
      render :new
    end
  end

  def show
    @campaign = Campaign.find params[:id]
    # render :show
  end

  def index
    @campaigns = Campaign.order("created_at ASC")
  end
end
