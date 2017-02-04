class WeightsController < ApplicationController
	before_action :logged_in_shepherd, only: [:create, :destroy, :edit]
	before_action :correct_shepherd, only: [:destroy, :edit]

  def create
		@animal = Animal.find_by(id: params[:animal_id])
		@weight = @animal.weights.build(weight_params)
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
  end

	def destroy
	end

	private
    def weight_params
			params.require(:weight).permit(:date, :weight, :weight_type)
		end

		def correct_shepherd
			@animal = current_shepherd.animals.find_by(id: params[:animal_id])
			@weight = @animal.weights.find_by(id: params[:id])
			redirect_to shepherd_animal_path(eartag: @animal.eartag, username: current_shepherd.username) if @weight.nil?
		end

end
