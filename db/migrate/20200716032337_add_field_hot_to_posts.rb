class AddFieldHotToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :hot, :boolean
    add_index :posts, :hot
  end
end
