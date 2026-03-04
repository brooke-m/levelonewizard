json.extract! signup, :id, :email, :address, :name, :current_step, :comms_preference, :created_at, :updated_at
json.url signup_url(signup, format: :json)
