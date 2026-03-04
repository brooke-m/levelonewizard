class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :address, null: false
      t.string :name, null: false
      t.boolean :comms_preference, null: false

      t.timestamps
    end
  end
end
