class CreateSubscriptionsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :external_id, null: false, index: { unique: true }
      t.integer :status, null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
