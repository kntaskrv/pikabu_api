class AddIndexToRate < ActiveRecord::Migration[6.0]
  def change
    add_index :rates, [:user_id, :rateable_id, :rateable_type], unique: true
  end
end
