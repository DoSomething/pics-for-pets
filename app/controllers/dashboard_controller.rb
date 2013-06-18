class DashboardController < ApplicationController
  layout 'dashboard'

  def index
  	@cats = Post.where(:animal_type => 'cat').count
  	@dogs = Post.where(:animal_type => 'dog').count
  	@others = Post.where(:animal_type => 'other').count

  	@total = (@cats + @dogs + @others)

	@dc = ((@dogs * 100) / @total)
  end
end
