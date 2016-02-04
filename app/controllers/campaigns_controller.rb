class CampaignsController < ApplicationController

  def new
    @campaign = Campaign.new
  end

  def create
    campaign_params = params.require(:campaign).permit(:name, :goal, :description, :end_date)
    @campaign = Campaign.create(campaign_params)
    # this sends a successful empty HTTP response (200)
    flash[:notice] = "Campaign created!"
    redirect_to campaign_path(@campaign)
  end
end
