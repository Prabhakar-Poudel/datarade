require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  test "should be valid" do
    subscription =
      Subscription.new(external_id: "999", status: :unpaid, user_id: 1)

    assert subscription.valid?
  end

  test "external_id should be present" do
    subscription = Subscription.new(status: :unpaid, user_id: 1)

    assert_not subscription.valid?
  end

  test "external_id should be unique" do
    subscription =
      Subscription.new(external_id: "999", status: :unpaid, user_id: 1)
    duplicate_subscription = subscription.dup

    subscription.save

    assert_not duplicate_subscription.valid?
  end

  test "status should be present" do
    subscription = Subscription.new(external_id: "999", user_id: 1)

    assert_not subscription.valid?
  end

  test "user_id should be present" do
    subscription = Subscription.new(external_id: "999", status: :unpaid)

    assert_not subscription.valid?
  end

  test "user_id should be valid" do
    subscription =
      Subscription.new(external_id: "999", status: :unpaid, user_id: 999)

    assert_not subscription.valid?
  end

  test "status should be one of the defined enum values" do
    subscription =
      Subscription.new(external_id: "999", status: :unpaid, user_id: 1)

    assert_includes Subscription.statuses.keys, subscription.status.to_s
  end

  test "should belong to a user" do
    subscription =
      Subscription.new(external_id: "999", status: :unpaid, user_id: 1)

    assert_instance_of User, subscription.user
  end
end
