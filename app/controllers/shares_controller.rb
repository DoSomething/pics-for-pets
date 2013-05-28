class SharesController < ApplicationController
  # POST /shares
  # POST /shares.json
  def create
    # Note: we can't put this in a model.  Models can't access the session variable.
    params[:share][:uid] = session[:drupal_user_id]
    @share = Share.new(params[:share])

    respond_to do |format|
      if @share.save
        format.html { render json: { 'success' => true } }
      else
        format.html { render json: { 'success' => true } }
      end
    end
  end
end