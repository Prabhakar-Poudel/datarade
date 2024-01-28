require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup { User.any_instance.stubs(:create_billing_customer).returns(nil) }

  test "should be valid with valid attributes" do
    user = User.new(email: "test@example.com", name: "John Doe")

    assert user.valid?
  end

  test "should not be valid without an email" do
    user = User.new(name: "John Doe")

    assert_not user.valid?
  end

  test "should not be valid without a name" do
    user = User.new(email: "test@example.com")

    assert_not user.valid?
  end

  test "should have a unique email" do
    User.create(email: "test@example.com", name: "John Doe")
    user = User.new(email: "test@example.com", name: "Jane Doe")

    assert_not user.valid?
  end

  test "should call create_billing_customer if billing_id is blank" do
    User.any_instance.expects(:create_billing_customer).returns(nil)

    user = User.new(email: "test@example.com", name: "John Doe")
    user.save!
  end

  test "should not call create_billing_customer if billing_id is present" do
    User.any_instance.expects(:create_billing_customer).never

    user =
      User.new(email: "test@example.com", name: "John Doe", billing_id: "123")
    user.save!
  end
end
