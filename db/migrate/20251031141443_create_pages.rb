class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.string :name
      t.text :description
      t.string :h1
      t.string :slug

      t.timestamps
    end
  end
end
