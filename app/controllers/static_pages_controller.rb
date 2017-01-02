class StaticPagesController < ApplicationController

  def home
		redirect_to shepherd_path(current_shepherd) if logged_in?
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
