require 'test_helper'

class ShepherdsIndexTest < ActionDispatch::IntegrationTest

	def setup
		@admin = shepherds(:michael)
		@non_admin = shepherds(:archer)
	end

	test "index as admin including pagination and delete links" do
		log_in_as(@admin)
		get shepherds_path
		assert_template 'shepherds/index'
		assert_select 'nav.pagination'
		first_page_of_shepherds = Shepherd.paginate(page: 1)

		#logged in user should not appear in the list of shepherds
		assert_no_match @admin.name, response.body

		first_page_of_shepherds.each do |shepherd|
			unless shepherd == @admin
				assert_select 'a[href=?]', shepherd_path(shepherd), text: shepherd.name
				assert_select 'a[href=?]', shepherd_path(shepherd), text: 'delete'
			end
		end
		assert_difference 'Shepherd.count', -1 do
			delete shepherd_path(@non_admin)
		end
	end

	test "index as non-admin" do
		log_in_as(@non_admin)
		get shepherds_path
		assert_select 'a', text: 'delete', count: 0
	end

end
