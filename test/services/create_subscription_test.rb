require "test_helper"

class CreateSubscriptionTest < ActiveSupport::TestCase
  test "should create a subscription" do
    existing_user = users(:WithBilling)

    external_subscription =
      Stripe::Subscription.construct_from(
        { id: "sub_12345", customer: existing_user.billing_id }
      )

    service = CreateSubscription.new(external_subscription)

    assert_difference "Subscription.count", 1 do
      service.call!
    end

    new_subscription = Subscription.last
    assert_equal existing_user, new_subscription.user
    assert_equal external_subscription.id, new_subscription.external_id
    assert_equal "unpaid", new_subscription.status
  end

  test "creates user and subscription if user is not present" do
    Stripe::Customer.stubs(:retrieve).returns(
      Stripe::Customer.construct_from(
        { id: "cus_12345", name: "Rick Sanchez", email: "rick@email.com" }
      )
    )

    external_subscription =
      Stripe::Subscription.construct_from(
        { id: "sub_12345", customer: "cus_12345" }
      )

    service = CreateSubscription.new(external_subscription)

    assert_difference "User.count", 1 do
      assert_difference "Subscription.count", 1 do
        service.call!
      end
    end

    new_user = User.last
    new_subscription = Subscription.last
    assert_equal "cus_12345", new_user.billing_id
    assert_equal "Rick Sanchez", new_user.name
    assert_equal "rick@email.com", new_user.email
    assert_equal new_user, new_subscription.user
    assert_equal external_subscription.id, new_subscription.external_id
    assert_equal "unpaid", new_subscription.status
  end
end
