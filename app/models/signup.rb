class Signup < ApplicationRecord
  validates :email, uniqueness: true, on: :create

  ###
  # the steps of a signup:
  # 0 - default, pre-sign up, enter email
  # 1 - email has been entered, enter name
  # 2 - name has been added, enter address
  # 3 - address has been added, check comms preference
  # 4 - comms preference has been added, check summary
  # 5 - summary confirmed, signup would fall under a 'complete' scope here
  # (if time to refactor, an enum on top of the saved int would be nicer)
  ###

  def first_step?
    current_step == 0
  end

  def last_step?
    current_step == 5
  end

  def increment_signup_step
    update(current_step: (current_step + 1)) unless last_step?
  end

  def decrement_signup_step
    update(current_step: (current_step - 1)) unless first_step?
  end
end
