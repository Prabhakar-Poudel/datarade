Rails.application.routes.draw do
  # Stripe webhook endpoint
  post "/stripe/webhooks", to: "stripe/webhooks#process_event"
end
