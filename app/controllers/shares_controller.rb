class SharesController < ApplicationController
  # POST /shares
  # POST /shares.json
  def create
    @share = Share.new(params[:share])

    respond_to do |format|
      if @share.save
        format.html { render json: { 'success' => true } }
        format.json { render json: @share, status: :created, location: @share }
      else
        format.html { render json: { 'success' => true } }
      end
    end
  end
end