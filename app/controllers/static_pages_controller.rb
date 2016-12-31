class StaticPagesController < ApplicationController

  def home
		if logged_in?
			@animals = current_shepherd.animals.paginate(page: params[:page])
			@animal = current_shepherd.animals.build if logged_in?
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
