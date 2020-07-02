class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :description

      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :title
  end
end
