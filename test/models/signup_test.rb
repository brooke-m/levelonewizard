require "test_helper"

class SignupTest < ActiveSupport::TestCase
  test "new signup can be created by email" do
    signup = Signup.new(email: "hello@test.com")
    assert signup.valid?
    assert signup.save
  end

  test "email cannot be used for more than one signup" do
    signup = Signup.new(email: "hello@test.com")
    assert signup.save

    signup_again = Signup.new(email: "hello@test.com")
    assert_not signup_again.valid?
    assert_not signup_again.save
  end

  test "increments current step" do
    signup = signups(:new_signup)
    signup.update(name: "New User")
    signup.increment_signup_step
    assert_equal signup.current_step, 2
  end

  test "decrements current step" do
    signup = signups(:complete_signup)
    signup.decrement_signup_step
    assert_equal signup.current_step, 4
  end

  test "can't go back before step 0" do
    signup = signups(:new_signup)
    signup.decrement_signup_step
    assert_equal signup.current_step, 0

    # take no action
    signup.decrement_signup_step
    assert_equal signup.current_step, 0
  end
end
