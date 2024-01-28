require "test_helper"

class DeleteBillingCustomerTest < ActiveSupport::TestCase
  test "removes billing_id for a user" do
    existing_user = users(:WithBilling)

    assert_not_nil existing_user.billing_id

    billing_customer = Customer.new(id: existing_user.billing_id)
    service = DeleteBillingCustomer.new(billing_customer)

    service.call!

    assert_nil existing_user.reload.billing_id
  end

  test "should not raise an error if user is not present" do
    billing_customer = Customer.new(id: "cus_zzzz")
    service = DeleteBillingCustomer.new(billing_customer)

    assert_nothing_raised { service.call! }
  end
end
