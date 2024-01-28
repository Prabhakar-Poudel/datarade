module Billable
  extend ActiveSupport::Concern

  included do
    def create_billing_customer
      Stripe::Customer.create({ email: email, name: name })
    end
  end
end
