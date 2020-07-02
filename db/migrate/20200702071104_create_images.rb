class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.references :imageable, polymorphic: true
      t.string :image, null: false
    end
  end
end
