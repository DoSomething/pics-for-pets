class UsersController < ApplicationController
  def intent
    user = User.find_by_uid(session[:drupal_user_id])
    user.intent = true
    user.save

    redirect_to :real_submit_path
  end
end
