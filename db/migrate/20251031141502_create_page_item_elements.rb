class CreatePageItemElements < ActiveRecord::Migration[8.0]
  def change
    create_table :page_item_elements do |t|
      t.references :page_item, null: false, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
