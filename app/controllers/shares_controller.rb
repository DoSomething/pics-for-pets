class SharesController < ApplicationController
  # POST /shares
  def create
    # Fail if you're not authenticated.
    render :status => :forbidden unless authenticated?

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