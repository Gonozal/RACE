require 'test_helper'

class WalletJournalsControllerTest < ActionController::TestCase
  setup do
    @wallet_journal = wallet_journals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wallet_journals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wallet_journal" do
    assert_difference('WalletJournal.count') do
      post :create, wallet_journal: @wallet_journal.attributes
    end

    assert_redirected_to wallet_journal_path(assigns(:wallet_journal))
  end

  test "should show wallet_journal" do
    get :show, id: @wallet_journal.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wallet_journal.to_param
    assert_response :success
  end

  test "should update wallet_journal" do
    put :update, id: @wallet_journal.to_param, wallet_journal: @wallet_journal.attributes
    assert_redirected_to wallet_journal_path(assigns(:wallet_journal))
  end

  test "should destroy wallet_journal" do
    assert_difference('WalletJournal.count', -1) do
      delete :destroy, id: @wallet_journal.to_param
    end

    assert_redirected_to wallet_journals_path
  end
end
