class CreateUserRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :user_requests do |t|
      t.string :name,             limit: 30
      t.string :email,            limit: 100
      t.string :region,           limit: 100, null: true
      t.string :application_area, limit: 150, null: true

      t.timestamps
    end
  end
end
