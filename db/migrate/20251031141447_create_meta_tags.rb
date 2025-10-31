class CreateMetaTags < ActiveRecord::Migration[8.0]
  def change
    create_table :meta_tags do |t|
      t.references :attachable, polymorphic: true, null: false
      t.text :title
      t.text :description
      t.text :keywords

      t.timestamps
    end
  end
end
