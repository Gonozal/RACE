require 'test_helper'

class EveNotificationsControllerTest < ActionController::TestCase
  setup do
    @eve_notification = eve_notifications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:eve_notifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create eve_notification" do
    assert_difference('EveNotification.count') do
      post :create, eve_notification: @eve_notification.attributes
    end

    assert_redirected_to eve_notification_path(assigns(:eve_notification))
  end

  test "should show eve_notification" do
    get :show, id: @eve_notification
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @eve_notification
    assert_response :success
  end

  test "should update eve_notification" do
    put :update, id: @eve_notification, eve_notification: @eve_notification.attributes
    assert_redirected_to eve_notification_path(assigns(:eve_notification))
  end

  test "should destroy eve_notification" do
    assert_difference('EveNotification.count', -1) do
      delete :destroy, id: @eve_notification
    end

    assert_redirected_to eve_notifications_path
  end
end
