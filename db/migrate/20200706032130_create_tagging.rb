class CreateTagging < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings do |t|
      t.integer :post_id, null: false
      t.integer :tag_id, null: false
    end
    add_index :taggings, %i[post_id tag_id], unique: true
  end
end
