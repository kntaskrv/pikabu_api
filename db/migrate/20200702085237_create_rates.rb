class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.integer :user_id, null: false
      t.references :rateable, polymorphic: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
