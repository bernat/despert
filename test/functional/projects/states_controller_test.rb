typerequire 'test_helper'

class Projects::typesControllerTest < ActionController::TestCase
  setup do
    @type = projects_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create type" do
    assert_difference('Projects::type.count') do
      post :create, :type => @type.attributes
    end

    assert_redirected_to type_path(assigns(:type))
  end

  test "should show type" do
    get :show, :id => @type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @type.to_param
    assert_response :success
  end

  test "should update type" do
    put :update, :id => @type.to_param, :type => @type.attributes
    assert_redirected_to type_path(assigns(:type))
  end

  test "should destroy type" do
    assert_difference('Projects::type.count', -1) do
      delete :destroy, :id => @type.to_param
    end

    assert_redirected_to projects_types_path
  end
end
