class CreateSubscription
  def initialize(external_subscription)
    @external_subscription = external_subscription
  end

  def call!
    ActiveRecord::Base.transaction do
      Subscription.create!(
        user: initialize_and_return_user,
        status: Subscription.statuses[:unpaid],
        external_id: @external_subscription.id
      )
    end
  end

  private

  def initialize_and_return_user
    user = User.find_by(billing_id: @external_subscription.customer)
    user.presence || CreateBillingCustomer.new(billing_customer).call!
  end

  def billing_customer
    Stripe::Customer.retrieve(@external_subscription.customer)
  end
end
