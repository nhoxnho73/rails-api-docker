class DeviceToken < ApplicationRecord
  belongs_to :user
  # validates :device_token, presence: true, unique: true

end