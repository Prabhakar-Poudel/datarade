class User < ApplicationRecord
  include Billable

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  after_create :create_billing_customer, if: -> { billing_id.blank? }
end
