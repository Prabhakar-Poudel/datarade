class Subscription < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :status, presence: true
  validates :user_id, presence: true

  belongs_to :user

  enum :status, { unpaid: 0, paid: 1, canceled: 2 }
end
