class StaticPagesController < ApplicationController
  # GET /start
  def guide
  end

  # GET /
  # This is for when the campaign closes -- static HTML for the finished gallery.
  def gallery
  end
end
