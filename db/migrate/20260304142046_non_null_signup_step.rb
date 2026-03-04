class NonNullSignupStep < ActiveRecord::Migration[8.1]
  def change
    change_column_null :signups, :current_step, false
  end
end
