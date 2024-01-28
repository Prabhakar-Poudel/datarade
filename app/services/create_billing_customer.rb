class CreateBillingCustomer
  def initialize(billing_customer)
    @billing_customer = billing_customer
  end

  def call!
    user = User.find_or_initialize_by(email: @billing_customer.email)
    user.billing_id = @billing_customer.id
    user.name = @billing_customer.name if user.name.blank?

    user.save!
    user
  end
end
