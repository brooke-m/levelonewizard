require "test_helper"

class SignupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @signup = signups(:new_signup)
  end

  test "should get index" do
    get signups_url
    assert_response :success
  end

  test "should get new" do
    get new_signup_url
    assert_response :success
  end

  test "should create signup" do
    assert_difference("Signup.count") do
      post signups_url, params: { signup: { email: "different@test.com", address: @signup.address, comms_preference: @signup.comms_preference, name: @signup.name } }
    end

    ## we are going to go to edit straight away
    # assert_redirected_to signup_url(Signup.last)
  end

  test "should show signup" do
    get signup_url(@signup)
    assert_response :success
  end

  test "should get edit" do
    get edit_signup_url(@signup)
    assert_response :success
  end

  test "should update by one step" do
    patch signup_url(@signup), params: { signup: { name: @signup.name } }

    ## we don't go back to shwo for this step
    # assert_redirected_to signup_url(@signup)
  end

  test "should destroy signup" do
    assert_difference("Signup.count", -1) do
      delete signup_url(@signup)
    end

    assert_redirected_to signups_url
  end
end
