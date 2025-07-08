require "test_helper"

class LaundromatsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get laundromats_index_url
    assert_response :success
  end

  test "should get show" do
    get laundromats_show_url
    assert_response :success
  end
end
