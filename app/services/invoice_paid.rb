class InvoicePaid
  def initialize(invoice)
    @invoice = invoice
  end

  def call!
    subscription = Subscription.find_by(external_id: @invoice.subscription)
    return if subscription.blank?

    subscription.update!(status: Subscription.statuses[:paid])
  end
end
