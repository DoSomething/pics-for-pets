class DashboardController < ApplicationController
  layout 'dashboard'

  # Before everything runs, run an authentication check and an API key check.
  before_filter :admin, :verify_api_key

  def index
  	@cats = Post.where(:animal_type => 'cat').count
  	@dogs = Post.where(:animal_type => 'dog').count
  	@others = Post.where(:animal_type => 'other').count

  	@total = (@cats + @dogs + @others)

	@dc = ((@dogs * 100) / @total)

	@users_last_week = Post.where('created_at > ?', 1.week.ago.to_date).count
  end
end
