class CreateSignups < ActiveRecord::Migration[8.1]
  def change
    create_table :signups do |t|
      t.string :email, null: false
      t.string :address
      t.string :name
      t.integer :current_step, default: 0
      t.boolean :comms_preference

      t.timestamps
    end
    add_index :signups, :email, unique: true
  end
end
