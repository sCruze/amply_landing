class CreatePageItems < ActiveRecord::Migration[8.0]
  def change
    create_table :page_items do |t|
      t.references :page, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :slug

      t.timestamps
    end
  end
end
