require "test_helper"

class CreateBillingCustomerTest < ActiveSupport::TestCase
  test "creates a customer if it does not exist" do
    billing_customer =
      Stripe::Customer.construct_from(
        id: "cus_1234",
        name: "John Doe",
        email: "new.john.doe@email.com"
      )
    service = CreateBillingCustomer.new(billing_customer)

    assert_difference "User.count", 1 do
      service.call!
    end

    new_user = User.last
    assert_equal billing_customer.id, new_user.billing_id
    assert_equal billing_customer.name, new_user.name
    assert_equal billing_customer.email, new_user.email
  end

  test "updates a customer if it already exists" do
    existing_user = users(:WithoutBilling)

    assert_nil existing_user.billing_id

    billing_customer =
      Stripe::Customer.construct_from(
        id: "cus_1234",
        email: "jannet.spancer@email.com"
      )
    service = CreateBillingCustomer.new(billing_customer)

    assert_no_difference "User.count" do
      service.call!
    end

    existing_user.reload
    assert_equal billing_customer.id, existing_user.billing_id
  end
end
