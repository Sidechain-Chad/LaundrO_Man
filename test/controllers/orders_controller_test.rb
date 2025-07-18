require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get orders_index_url
    assert_response :success
  end

  test "should get show" do
    get orders_show_url
    assert_response :success
  end

  test "should get new" do
    get orders_new_url
    assert_response :success
  end

  test "should get create" do
    get orders_create_url
    assert_response :success
  end

  test "should get confirmation" do
    get orders_confirmation_url
    assert_response :success
  end

  test "should get cancel" do
    get orders_cancel_url
    assert_response :success
  end

  test "should get order_trackings" do
    get orders_order_trackings_url
    assert_response :success
  end
end
