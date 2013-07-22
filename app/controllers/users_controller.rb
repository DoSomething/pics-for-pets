class UsersController < ApplicationController
  # GET /submit/guide
  # Saves if a user is going into the submit form.
  def intent
    if !authenticated?
      redirect_to :login
      return false
    end

    # Save the intent to submit.
    user = User.find_by_uid(session[:drupal_user_id])
    user.intent = true
    user.save

    # Bring them to the real submit path.
    redirect_to :start
  end
end
