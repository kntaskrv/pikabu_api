class AddIndexToBookmarks < ActiveRecord::Migration[6.0]
  def change
    add_index :bookmarks, [:user_id, :markable_id, :markable_type], unique: true
  end
end
