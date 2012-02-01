require 'test_helper'

class MarketTransactionsControllerTest < ActionController::TestCase
  setup do
    @market_transaction = market_transactions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:market_transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create market_transaction" do
    assert_difference('MarketTransaction.count') do
      post :create, market_transaction: @market_transaction.attributes
    end

    assert_redirected_to market_transaction_path(assigns(:market_transaction))
  end

  test "should show market_transaction" do
    get :show, id: @market_transaction.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @market_transaction.to_param
    assert_response :success
  end

  test "should update market_transaction" do
    put :update, id: @market_transaction.to_param, market_transaction: @market_transaction.attributes
    assert_redirected_to market_transaction_path(assigns(:market_transaction))
  end

  test "should destroy market_transaction" do
    assert_difference('MarketTransaction.count', -1) do
      delete :destroy, id: @market_transaction.to_param
    end

    assert_redirected_to market_transactions_path
  end
end
