require 'test_helper'

class EveMailsControllerTest < ActionController::TestCase
  setup do
    @eve_mail = eve_mails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:eve_mails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create eve_mail" do
    assert_difference('EveMail.count') do
      post :create, eve_mail: @eve_mail.attributes
    end

    assert_redirected_to eve_mail_path(assigns(:eve_mail))
  end

  test "should show eve_mail" do
    get :show, id: @eve_mail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @eve_mail
    assert_response :success
  end

  test "should update eve_mail" do
    put :update, id: @eve_mail, eve_mail: @eve_mail.attributes
    assert_redirected_to eve_mail_path(assigns(:eve_mail))
  end

  test "should destroy eve_mail" do
    assert_difference('EveMail.count', -1) do
      delete :destroy, id: @eve_mail
    end

    assert_redirected_to eve_mails_path
  end
end
