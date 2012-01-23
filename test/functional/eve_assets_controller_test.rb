require 'test_helper'

class EveAssetsControllerTest < ActionController::TestCase
  setup do
    @eve_asset = eve_assets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:eve_assets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create eve_asset" do
    assert_difference('EveAsset.count') do
      post :create, eve_asset: @eve_asset.attributes
    end

    assert_redirected_to eve_asset_path(assigns(:eve_asset))
  end

  test "should show eve_asset" do
    get :show, id: @eve_asset.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @eve_asset.to_param
    assert_response :success
  end

  test "should update eve_asset" do
    put :update, id: @eve_asset.to_param, eve_asset: @eve_asset.attributes
    assert_redirected_to eve_asset_path(assigns(:eve_asset))
  end

  test "should destroy eve_asset" do
    assert_difference('EveAsset.count', -1) do
      delete :destroy, id: @eve_asset.to_param
    end

    assert_redirected_to eve_assets_path
  end
end
