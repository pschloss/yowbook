require 'test_helper'

class AnimalsControllerTest < ActionDispatch::IntegrationTest

	def setup
		@animal = animals(:first)
	end

	test "should redirect create when not logged in" do
		assert_no_difference 'Animal.count' do
			post animals_path, params: { animal: { eartag: "12345G", birth_date: "2015-04-01" } }
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy when not logged in" do
		assert_no_difference 'Animal.count' do
			delete animal_path(@animal)
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy for wrong animal" do
		log_in_as(shepherds(:michael))
		animal = animals(:archer_sheep_1)
		assert_no_difference 'Animal.count' do
			delete animal_path(animal)
		end
		assert_redirected_to shepherd_path(shepherds(:michael))
	end
end
