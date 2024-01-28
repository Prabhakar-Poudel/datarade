class Stripe::WebhooksController < ApplicationController
  before_action :set_event

  def process_event
    case @event.type
    when "customer.created"
      set_customer
      return head :bad_request unless valid_customer?

      CreateBillingCustomer.new(@customer).call!
    when "customer.deleted"
      set_customer
      return head :bad_request unless valid_customer?

      DeleteBillingCustomer.new(@customer).call!
    when "invoice.paid"
      set_invoice
      InvoicePaid.new(@invoice).call!
    when "customer.subscription.created"
      set_subscription
      CreateSubscription.new(@subscription).call!
    when "customer.subscription.deleted"
      set_subscription
      CancelSubscription.new(@subscription).call!
    else
      puts "Unhandled event type: #{@event.type}"
    end

    head :no_content
  end

  private

  def set_event
    @event = extract_stripe_event
  rescue JSON::ParserError
    head :bad_request
  rescue Stripe::SignatureVerificationError
    head :bad_request
  end

  def extract_stripe_event
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret =
      Rails.application.credentials.stripe_webhook_endpoint_secret
    Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
  end

  def set_customer
    @customer = @event.data.object
  end

  def valid_customer?
    @customer.email.present? && @customer.name.present?
  end

  def set_invoice
    @invoice = @event.data.object
  end

  def set_subscription
    @subscription = @event.data.object
  end
end
