class CancelSubscription
  def initialize(external_subscription)
    @external_subscription = external_subscription
  end

  def call!
    subscription = Subscription.find_by(external_id: @external_subscription.id)
    return if subscription.blank?
    return unless subscription.paid?

    subscription.update!(status: Subscription.statuses[:canceled])
  end
end
