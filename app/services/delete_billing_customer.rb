class DeleteBillingCustomer
  def initialize(billing_customer)
    @billing_customer = billing_customer
  end

  def call!
    user = User.find_by(billing_id: @billing_customer.id)
    user.update!(billing_id: nil) if user.present?
  end
end
