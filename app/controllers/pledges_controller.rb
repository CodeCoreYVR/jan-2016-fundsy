class PledgesController < ApplicationController
  before_action :authenticate_user

  def create
    @campaign        = Campaign.find params[:campaign_id]
    @pledge          = Pledge.new pledge_params
    @pledge.campaign = @campaign
    @pledge.user     = current_user
    @pledge.save
    render nothing: true
  end

  private

  def pledge_params
    params.require(:pledge).permit(:amount)
  end
end
