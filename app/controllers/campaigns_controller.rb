class CampaignsController < ApplicationController
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  def new
    @campaign = Campaign.new
  end

  def create
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
    # render :show
  end

  def index
    @campaigns = Campaign.order("created_at ASC")
  end

  def edit
  end

  def update
    if @campaign.update campaign_params
      redirect_to campaign_path(@campaign), notice: "Campaign updated!"
    else
      flash[:alert] = "Campaign not updated!"
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_path, notice: "Campaign deleted!"
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :goal, :description, :end_date)
  end

  def find_question
    @campaign = Campaign.find params[:id]
  end
end
