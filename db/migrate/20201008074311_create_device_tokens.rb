class CreateDeviceTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :device_tokens do |t|
      t.bigint :user_id
      t.string :device_token
    end
  end
end
