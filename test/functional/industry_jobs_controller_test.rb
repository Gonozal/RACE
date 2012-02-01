require 'test_helper'

class IndustryJobsControllerTest < ActionController::TestCase
  setup do
    @industry_job = industry_jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:industry_jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create industry_job" do
    assert_difference('IndustryJob.count') do
      post :create, industry_job: @industry_job.attributes
    end

    assert_redirected_to industry_job_path(assigns(:industry_job))
  end

  test "should show industry_job" do
    get :show, id: @industry_job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @industry_job
    assert_response :success
  end

  test "should update industry_job" do
    put :update, id: @industry_job, industry_job: @industry_job.attributes
    assert_redirected_to industry_job_path(assigns(:industry_job))
  end

  test "should destroy industry_job" do
    assert_difference('IndustryJob.count', -1) do
      delete :destroy, id: @industry_job
    end

    assert_redirected_to industry_jobs_path
  end
end
