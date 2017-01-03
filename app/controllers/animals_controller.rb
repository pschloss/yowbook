class AnimalsController < ApplicationController
	before_action :logged_in_shepherd, only: [:create, :destroy]
	before_action :correct_shepherd, only: :destroy

	def create
		@shepherd = current_shepherd
		@animal = current_shepherd.animals.build(animal_params)

		if @animal.save
			flash[:success] = "Sheep added!"
			# render 'shepherds/show'
			redirect_to shepherd_path(current_shepherd)
		else
			redirect_to shepherd_path(current_shepherd)
		end
	end

	def destroy
		@animal.destroy
		flash[:success] = "Animal's records deleted"
		redirect_to request.referrer || shepherd_path(current_shepherd)
	end


	private

		def animal_params
			params.require(:animal).permit(:eartag, :birth_date, :picture, :dam, :sire)
		end

		def correct_shepherd
			@animal = current_shepherd.animals.find_by(id: params[:id])
			redirect_to shepherd_path(current_shepherd) if @animal.nil?
		end

end
