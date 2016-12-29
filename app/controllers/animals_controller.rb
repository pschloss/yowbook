class AnimalsController < ApplicationController
	before_action :logged_in_shepherd, only: [:create, :destroy]
	before_action :correct_shepherd, only: :destroy

	def create
		@animal = current_shepherd.animals.build(animal_params)
		if @animal.save
			flash[:success] = "Sheep added!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@animal.destroy
		flash[:success] = "Animal's records deleted"
		redirect_to request.referrer || root_url
	end


	private

		def animal_params
			params.require(:animal).permit(:eartag, :birth_date)
		end

		def correct_shepherd
			@animal = current_shepherd.animals.find_by(id: params[:id])
			redirect_to root_url if @animal.nil?
		end
end
