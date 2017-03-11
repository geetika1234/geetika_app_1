class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :product_id
      t.string :tag_value
      t.timestamps null: false
    end
  end
end
