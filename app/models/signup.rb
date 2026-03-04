class Signup < ApplicationRecord
  validates :email, presence: true, uniqueness: true, on: :create
  validate :valid_step_transition, on: [ :create, :update ]

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

  def valid_step_transition
    errors.add(:email, "invalid step movement") unless ready_for_next_step
  end

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

   private

  def ready_for_next_step
    case current_step
    when 0
      true
    when 1
      !!self.email
    when 2
      !!self.name
    when 3
      !!self.address
    when 4
      !!self.comms_preference
    else
      false
    end
  end
end
