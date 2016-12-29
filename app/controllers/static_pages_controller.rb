class StaticPagesController < ApplicationController

  def home
		if logged_in?
			@animal = current_shepherd.animals.build if logged_in?
			@feed_items = current_shepherd.feed.paginate(page: params[:page])
		end
  end

	def help
	end

  def about
  end

  def contact
  end

  def news
  end
end
