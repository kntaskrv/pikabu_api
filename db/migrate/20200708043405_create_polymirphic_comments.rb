class CreatePolymirphicComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.references :commentable, polymorphic: true
      t.string :text, null: false

      t.timestamps
    end
    add_column :comments, :deleted_at, :datetime
    add_index :comments, :deleted_at
    add_index :comments, :user_id
  end
end
