class AnimalsController < ApplicationController
	before_action :logged_in_shepherd, only: [:create, :destroy, :show]
	before_action :correct_shepherd, only: [:destroy,:edit]

	def create
		@shepherd = current_shepherd
		@new_animal = current_shepherd.animals.build(animal_params)

		if @new_animal.save
			flash[:success] = "Sheep added!"
			redirect_to shepherd_path(current_shepherd)
		else
			@animals = @shepherd.animals.paginate(page: params[:page])
			render 'shepherds/show'
		end
	end

	def destroy
		@animal.destroy
		flash[:success] = "Animal's records deleted"
		redirect_to shepherd_path(current_shepherd)
	end

	def show
		@shepherd = Shepherd.find_by(username: params[:username])
		@animal = Animal.find_by(shepherd_id: @shepherd.id, eartag: params[:eartag])
		@weight = @animal.weights.build if logged_in?
	end

	def update
		@animal = Animal.find(params[:id])

		if @animal.update_attributes(animal_params)
			flash[:success] = "Animal updated"
			@error = false
			redirect_to shepherd_animal_path(username: current_shepherd[:username], eartag: @animal.eartag)
		else
			@shepherd = @animal.shepherd
			@weight = Weight.new
			@error = true
			render 'animals/show'
		end
	end

	def edit
	end

	private

		def animal_params
			params.require(:animal).permit(:eartag, :birth_date, :picture, :dam, :sire, :sex, :status, :status_date)
		end

		def correct_shepherd
			@animal = current_shepherd.animals.find_by(id: params[:id])
			redirect_to shepherd_path(current_shepherd) if @animal.nil?
		end

end
