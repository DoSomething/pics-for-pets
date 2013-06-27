class DashboardController < ApplicationController
  layout 'dashboard'

  # Before everything runs, run an authentication check and an API key check.
  before_filter :admin, :verify_api_key

  def index
    #post stats
  	@cats = Post.where(:animal_type => 'cat').count
  	@dogs = Post.where(:animal_type => 'dog').count
  	@others = Post.where(:animal_type => 'other').count
    @pets = (@cats + @dogs + @others)

    #user stats
    @users = User.all.count

    #share stats
    @shares = 0
    @catShares = 0
    @dogShares = 0
    @otherShares = 0
    @posts = Post.all
    @posts.each do |post|
      if !post.share_count.nil?
        @shares += post.share_count
        if post.animal_type == "cat"
          @catShares += post.share_count
        end
        if post.animal_type == "dog"
          @dogShares += post.share_count
        end
        if post.animal_type == "other"
          @otherShares += post.share_count
        end
      end
    end
  end

end
