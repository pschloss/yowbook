class AnimalsController < ApplicationController
	before_action :logged_in_shepherd, only: [:create, :destroy, :show]
	before_action :correct_shepherd, only: [:edit, :destroy]

	def create
		@shepherd = current_shepherd
		@animal = current_shepherd.animals.build(animal_params)

		if @animal.save
			flash[:success] = "Sheep added!"
			# render 'shepherds/show'
			redirect_to shepherd_path(current_shepherd)
		else
			@animals = @shepherd.animals.paginate(page: params[:page])
			render 'shepherds/show'
		end
	end

	def destroy
		@animal.destroy
		flash[:success] = "Animal's records deleted"
		redirect_to request.referrer || shepherd_path(current_shepherd)
	end

	def show
		@shepherd = Shepherd.find_by(username: params[:username])
		@animal = @shepherd.animals.find_by(eartag: params[:eartag])
		render 'edit' if @shepherd == current_shepherd
	end

	def edit
		@animal = Animal.find_by(eartag: params[:eartag])
		@shepherd = @animal.shepherd
	# @animal = current_shepherd.animals.build if logged_in?
	end

	def update
		@animal = Animal.find(params[:id])
		if @animal.update_attributes(animal_params)
			flash[:success] = "Post updated"
			redirect_to user_animal_path(username: params[:id])
		else
			render 'edit'
		end
	end

	private

		def animal_params
			params.require(:animal).permit(:eartag, :birth_date, :picture, :dam, :sire, :sex)
		end

		def correct_shepherd
			@animal = current_shepherd.animals.find_by(id: params[:id])
			redirect_to shepherd_path(current_shepherd) if @animal.nil?
		end

end
