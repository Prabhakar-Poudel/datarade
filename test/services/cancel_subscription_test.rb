require "test_helper"

class CancelSubscriptionTest < ActiveSupport::TestCase
  test "cancels a paid subscription" do
    subscription = subscriptions(:paid)
    external_subscription =
      Stripe::Subscription.construct_from({ id: subscription.external_id })
    service = CancelSubscription.new(external_subscription)

    service.call!

    assert_equal "canceled", subscription.reload.status
  end

  test "does not cancel an unpaid subscription" do
    subscription = subscriptions(:unpaid)
    external_subscription =
      Stripe::Subscription.construct_from({ id: subscription.external_id })
    service = CancelSubscription.new(external_subscription)

    service.call!

    assert_equal "unpaid", subscription.reload.status
  end

  test "does not raise on non existing subscription" do
    external_subscription =
      Stripe::Subscription.construct_from({ id: "FAKE_ID" })
    service = CancelSubscription.new(external_subscription)

    assert_nothing_raised { service.call! }
  end
end
