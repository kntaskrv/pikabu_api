class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.integer :post_id, null: false
      t.string :tag, null: false
    end
    add_index :tags, :post_id
  end
end
