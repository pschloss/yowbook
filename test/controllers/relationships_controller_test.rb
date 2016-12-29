require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

	test "create should require logged-in shepherd" do
		assert_no_difference 'Relationship.count' do
			post relationships_path
		end
		assert_redirected_to login_url
	end

	test "destroy should require logged-in shepherd" do
		assert_no_difference 'Relationship.count' do
			delete relationship_path(relationships(:one))
		end
	end


end
