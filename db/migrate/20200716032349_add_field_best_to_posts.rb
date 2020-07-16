class AddFieldBestToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :best, :boolean
    add_index :posts, :best
  end
end
