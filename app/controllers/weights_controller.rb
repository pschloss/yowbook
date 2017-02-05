class WeightsController < ApplicationController
	before_action :logged_in_shepherd, only: [:create, :destroy, :edit]
	before_action :correct_shepherd, only: [:destroy, :edit]

	def new
		@weight = Weight.new
	end

  def create
		@animal = Animal.find_by(id: params[:animal_id])
		@weight = @animal.weights.new(weight_params)
		if @weight.save
			flash[:success] = "Weight recorded  !"
			redirect_to shepherd_animal_path(eartag: @animal.eartag, username: current_shepherd.username)
		else
			@shepherd = Shepherd.find_by(id: @animal.shepherd_id)
			@weights = @animal.weights.reject { |w| w.id.nil? || w.id == ''}
			render 'animals/show'
		end
  end

  def edit
		@weight = Weight.find(params[:id])
		@shepherd = current_shepherd
		@animal = Animal.find(@weight.animal_id)
		@weights = @animal.weights
		render 'animals/show'
  end

	def update
		@weight = Weight.find(params[:id])
		@animal = Animal.find(@weight.animal_id)

		if @weight.update_attributes(weight_params)
			flash[:success] = "Weight updated"
			redirect_to shepherd_animal_path(eartag: @animal.eartag, username: current_shepherd.username)
		else
			@shepherd = Shepherd.find_by(id: @animal.shepherd_id)
			@weights = @animal.weights.reject { |w| w.id.nil? || w.id == ''}
			render 'animals/show'
		end

	end

	def destroy
		Weight.find(params[:id]).destroy
		flash[:success] = "Weight record deleted"
		@shepherd = @animal.shepherd
		@weights = @animal.weights
		redirect_to shepherd_animal_path(eartag: @animal.eartag, username: current_shepherd.username)
	end

	private
    def weight_params
			params.require(:weight).permit(:date, :weight, :weight_type)
		end

		def correct_shepherd
			@animal = current_shepherd.animals.find_by(params[:id])
			@weight = @animal.weights.find_by(params[:id])
			redirect_to shepherd_animal_path(eartag: @animal.eartag, username: current_shepherd.username) if @weight.nil?
		end

end
