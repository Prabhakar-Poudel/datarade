require "test_helper"

class InvoicePaidTest < ActiveSupport::TestCase
  test "updates subscription status to paid" do
    subscription = subscriptions(:unpaid)
    invoice =
      Stripe::Invoice.construct_from(
        { id: "in_12345", subscription: subscription.external_id }
      )
    service = InvoicePaid.new(invoice)

    service.call!

    assert_equal "paid", subscription.reload.status
  end

  test "does not raise if subscription is not found" do
    invoice =
      Stripe::Invoice.construct_from(
        { id: "in_12345", subscription: "FAKE_SUB" }
      )
    service = InvoicePaid.new(invoice)

    assert_nothing_raised { service.call! }
  end
end
